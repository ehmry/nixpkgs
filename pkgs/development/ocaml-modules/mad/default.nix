{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, libmad }:

buildDunePackage rec {
  pname = "mad";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-kdm+MPitUvKZg6WAMXV+YFtAKFFLsmfcPxHs4FCkq10=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libmad ];

  meta = {
    description = "Mad decoding library";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
