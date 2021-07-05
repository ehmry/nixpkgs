{ lib, fetchFromGitHub, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "dtools";
  version = "0.4.3";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-2EyHRUPqchaPFF5rrElm6FUOWJz/FXweg5nx2Q++Y4c=";
  };

  minimumOCamlVersion = "4.05";

  useDune2 = true;

  # buildInputs = [ dune-configurator ];
  # propagatedBuildInputs = [ odoc ];

  meta = {
    description = "Library providing various helper functions to make daemons";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
