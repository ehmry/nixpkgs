{ buildNimblePackage, fetchgit, python2 }:
let
  nimble = with builtins; fromJSON (readFile ./nimble.json);
  python = python2;
in
buildNimblePackage {
  nimbleMeta = nimble.meta;
  version = "head";
  src = fetchgit {
    inherit (nimble.src) url rev sha256;
  };
  patches = [ ./patch ];
  nimbleLdFlags = [
    "-L${python}/lib" "-l${python.libPrefix}"
  ];
}
