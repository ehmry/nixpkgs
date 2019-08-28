{ buildNimblePackage, fetchgit, snappy }:
let
  nimble = with builtins; fromJSON (readFile ./nimble.json);
in
buildNimblePackage {
  nimbleMeta = nimble.meta;
  version = "head";
  src = fetchgit {
    inherit (nimble.src) url rev sha256;
  };
  propagatedBuildInputs = [ snappy ];
}
