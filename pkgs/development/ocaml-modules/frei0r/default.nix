{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, pkg-config, frei0r
}:

buildDunePackage rec {
  pname = "frei0r";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-eh/ymZO/3a1z6uvZdnXgma/7AU2NBVs2lddA+R/kuQA=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator pkg-config ];
  buildInputs = [ frei0r ];

  meta = {
    description = "Bindings for the frei0r API which provides video effects";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
