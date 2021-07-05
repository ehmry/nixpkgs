{ lib, fetchurl, buildDunePackage, dune-configurator, pkg-config  }:

buildDunePackage rec {
  pname = "shine";
  version = "0.2.1";
  src = fetchurl {
    url = "https://github.com/savonet/ocaml-${pname}/releases/download/${version}/ocaml-${pname}-${version}.tar.gz";
    hash = "sha256-3KI3lOvNY/ZKAAJEt2K7uojrmJyqDAKXi0MRdpBsOAI=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ ];

  meta = {
    description = "Fixed-point MP3 encoder";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
