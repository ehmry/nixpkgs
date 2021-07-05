{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, ocaml_pcre }:

buildDunePackage rec {
  pname = "duppy";
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-w4AdGUoIA4RUdbobDqW/4uS9+5TXAHMLiWysUJ0UxxY=";
  };

  minimumOCamlVersion = "4.03";

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ocaml_pcre ];

  meta = {
    description = "Library providing monadic threads";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
