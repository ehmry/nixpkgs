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
    cbor = callNimblePackge "cbor" ./cbor { };

    cligen = callNimblePackge "cligen" ./cligen { };

    hmac = callNimblePackge "hmac" ./hmac { };

    masterpassword = callNimblePackge "masterpassword" ./masterpassword { };

    mpwc = callNimblePackge "mpwc" ./mpwc { };

    nimSHA2 = callNimblePackge "nimSHA2" ./nimSHA2 { };

    sha1 = callNimblePackge "sha1" ./sha1 { };

    python = callNimblePackge "python" ./python { };

    rocksdb = callNimblePackge "rocksdb" ./rocksdb {
      inherit (pkgs) rocksdb; };

    snappy = callNimblePackge "snappy" ./snappy {
      inherit (pkgs) snappy; };

    spry = callNimblePackge "spry" ./spry { };

    spryvm = callNimblePackge "spryvm" ./spryvm { };

    stew = callNimblePackge "stew" ./stew { };

    tempfile = callNimblePackge "tempfile" ./tempfile { };

    ui = callNimblePackge "ui" ./ui { };
  };
in lib.fix nimblePackages
