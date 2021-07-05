{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, libao
}:

buildDunePackage rec {
  pname = "ao";
  version = "0.2.3";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-PTThvKYKlDTTFRcRjkJJP5TuvNl10q9XG7rsZ/11tK4=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator ];
  buildInputs = [ libao ];

  meta = {
    description = "Bindings for the AO library which provides high-level functions for using soundcards";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
