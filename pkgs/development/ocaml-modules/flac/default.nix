{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, flac, pkg-config, ogg  }:

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

  nativeBuildInputs = [ dune-configurator pkg-config ];
  buildInputs = [ flac ];
  propagatedBuildInputs = [ ogg ];

  meta = {
    description = "Bindings to libflac";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
