{
  lib,
  buildPackages,
  stdenv,
  nim1,
  nim2,
  nim_builder,
  defaultNimVersion ? 2,
  nimOverrides,
}:

let
  fodFromLockEntry =
    let
      methods = {
        fetchzip =
          { url, sha256, ... }:
          buildPackages.fetchzip {
            name = "source";
            inherit url sha256;
          };
        git =
          {
            fetchSubmodules,
            leaveDotGit,
            rev,
            sha256,
            url,
            ...
          }:
          buildPackages.fetchgit {
            inherit
              fetchSubmodules
              leaveDotGit
              rev
              sha256
              url
              ;
          };
      };
    in
    attrs@{ method, ... }:
    let
      fod = methods.${method} attrs;
    in
    ''--path:"${fod.outPath}/${attrs.srcDir}"'';

  nimBuilderFunc =
    {
      depsBuildBuild ? [ ],
      nativeBuildInputs ? [ ],
      lockFile ? null,
      nimFlags ? [ ],
      requiredNimVersion ? defaultNimVersion,
      passthru ? { },
      ...
    }@prevAttrs:
    let

      lockAttrs = lib.attrsets.optionalAttrs (lockFile != null) (
        builtins.fromJSON (builtins.readFile lockFile)
      );

      lockDepends = lockAttrs.depends or [ ];

      lockFileNimFlags = map fodFromLockEntry lockDepends;
    in
    (
      if requiredNimVersion == 1 then
        {
          depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
          nativeBuildInputs = [ nim1 ] ++ nativeBuildInputs;
        }
      else if requiredNimVersion == 2 then
        {
          depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
          nativeBuildInputs = [ nim2 ] ++ nativeBuildInputs;
        }
      else
        throw "requiredNimVersion ${toString requiredNimVersion} is not valid"
    )
    // {
      strictDeps = true;
      enableParallelBuilding = true;
      doCheck = true;
      nimFlags = lockFileNimFlags ++ nimFlags;
      configurePhase =
        prevAttrs.configurePhase or ''
          runHook preConfigure
          export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
          nim_builder --phase:configure
          runHook postConfigure
        '';
      buildPhase =
        prevAttrs.buildPhase or ''
          runHook preBuild
          nim_builder --phase:build
          runHook postBuild
        '';
      checkPhase =
        prevAttrs.checkPhase or ''
          runHook preCheck
          nim_builder --phase:check
          runHook postCheck
        '';
      installPhase =
        prevAttrs.installPhase or ''
          runHook preInstall
          nim_builder --phase:install
          runHook postInstall
        '';

      passthru = {
        inherit lockDepends;
      };

      meta = lib.attrsets.recursiveUpdate { inherit (nim2.meta) maintainers platforms; } (
        prevAttrs.meta or { }
      );
    };
in
buildNimPackageArgs:
let
  composition =
    finalAttrs:
    let
      callerAttrs =
        if builtins.isAttrs buildNimPackageArgs then
          buildNimPackageArgs
        else
          buildNimPackageArgs finalAttrs;

      nimBuilderAttrs = callerAttrs // (nimBuilderFunc callerAttrs);

      applyOverrides =
        prevAttrs:
        builtins.foldl' (
          prevAttrs:
          { packages, ... }@lockAttrs:
          builtins.foldl' (
            prevAttrs: name:
            if (builtins.hasAttr name nimOverrides) then
              (prevAttrs // (nimOverrides.${name} lockAttrs prevAttrs))
            else
              prevAttrs
          ) prevAttrs packages
        ) prevAttrs prevAttrs.passthru.lockDepends;

      attrs = nimBuilderAttrs // (applyOverrides nimBuilderAttrs);
    in
    lib.trivial.warnIf (builtins.hasAttr "nimBinOnly" attrs)
      "the nimBinOnly attribute is deprecated for buildNimPackage"
      attrs;
in
stdenv.mkDerivation composition
