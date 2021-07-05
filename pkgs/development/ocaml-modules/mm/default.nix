{ lib, fetchFromGitHub, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "mm";
  version = "0.7.1";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-6zrpyGlrl9T/ZhPFYwlYq3uUfEJUtgehp+fZTZw1Rds=";
  };

  minimumOCamlVersion = "4.03";

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  # propagatedBuildInputs = [ ];

  meta = {
    description = "Library providing monadic threads";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
