{ buildNimblePackage, fetchgit, spryvm, openssl, sqlite }:
let
  nimble = with builtins; fromJSON (readFile ./nimble.json);
in
buildNimblePackage {
  nimbleMeta = nimble.meta;
  version = "head";
  src = fetchgit {
    inherit (nimble.src) url rev sha256;
  };

  nimbleInputs = [ spryvm ];
  buildInputs = [ openssl sqlite ];

  NIX_LDFLAGS = [
    "-lcrypto"
    "-lsqlite3"
  ];

}
