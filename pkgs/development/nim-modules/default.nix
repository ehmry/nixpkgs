{ lib, pkgs, callPackage }:

let
  extractNimbleMeta = with builtins;
    let pkgsList = fromJSON (readFile ./packages_official.json);
    in name: head (filter (pkg: name == pkg.name) pkgsList);

  nimblePackages = self: let
    callNimblePackge = name: path: args:
      let
        nimbleMeta = extractNimbleMeta name;
        args' =
        { buildNimblePackage =
            callPackage ./build-nimble-package args;
        } // args;
      in
      lib.callPackageWith (pkgs // self) path args';
  in
  rec {

  };
in lib.fix nimblePackages
