{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, pkg-config
, pulseaudio }:

buildDunePackage rec {
  pname = "pulseaudio";
  version = "0.1.4";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-5jXB3gJlmbtfoHW123yLrly2Bg2SwgZOGF10GUofr+g=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator pkg-config ];
  buildInputs = [ pulseaudio ];

  meta = {
    description = "Bindings to Pulseaudio client library";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
