{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, flac, pkg-config  }:

buildDunePackage rec {
  pname = "flac";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-qltOcSP91nsHXbXnbGb8koJgVvAD9Tj/i71pMG5e7hk=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ flac ];

  meta = {
    description = "Bindings to libflac";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
