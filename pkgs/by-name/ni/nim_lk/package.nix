{ lib, buildNimPackage, fetchFromSourcehut, openssl }:

buildNimPackage (finalAttrs: {
  pname = "nim_lk";
  version = "20231031";
  nimBinOnly = true;

  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = "nim_lk";
    rev = finalAttrs.version;
    hash = "sha256-dXm3dfXAxgucek19f1KdRShOsJyELPTB32qgGSKId6A=";
  };

  buildInputs = [ openssl ];

  lockFile = ./lock.json;

  meta = finalAttrs.src.meta // {
    description = "Generate Nix specific lock files for Nim packages";
    homepage = "https://git.sr.ht/~ehmry/nim_lk";
    mainProgram = "nim_lk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
