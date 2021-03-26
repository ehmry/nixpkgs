{ lib
, stdenv
# common
, ocaml
, mirage
, dune_2
, ocamlbuild
, findlib
, pkg-config
# unix target
, mirage-unix
# xen target
, mirage-xen
}:

{ target ? "unix"
, pname
, version
, ...
}@args:

let
  installPhases = {
    unix = ''
      install -Dm755 main.native "$out/bin/${pname}"
    '';
    xen = ''
      install -Dm644 -t "$out/share/${pname}" \
        ${pname}.xen \
        ${pname}.xl \
        ${pname}.xl.in \
        ${pname}_libvirt.xml \
    '';
  };
in

assert lib.assertOneOf "target" target (builtins.attrNames installPhases);

# TODO(sterni): make target overrideable?
# TODO(sterni): additional targets
# TODO(sterni): additional configure flags
# TODO(sterni): is mirage configure deterministic? convenience tooling to find out precise deps?

stdenv.mkDerivation ({
  name = "ocaml${ocaml.version}-${pname}-${version}";

  # prevents mirage from calling `opam config var prefix`
  PREFIX = "/bogus/directory";

  configurePhase = ''
    runHook preConfigure
    mirage configure -t ${target}
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    mirage build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${installPhases."${target}"}
    runHook postInstall
  '';
} // args // {
  nativeBuildInputs = [
    mirage.out
    ocamlbuild
    findlib
    dune_2
    ocaml
    pkg-config
  ] ++ (args.nativeBuildInputs or []);

  buildInputs = [
    mirage
  ] ++ lib.optionals (target == "unix") [
    mirage-unix
  ] ++ lib.optionals (target == "xen") [
    mirage-xen
  ] ++ (args.buildInputs or []);

  meta =  {
    platforms =
      if target == "unix"
      then lib.platforms.unix
      else ocaml.meta.platforms;
  } // (args.meta or {});
})
