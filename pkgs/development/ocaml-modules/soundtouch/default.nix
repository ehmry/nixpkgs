{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, soundtouch }:

buildDunePackage rec {
  pname = "soundtouch";
  version = "0.1.9";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-81Mhk4PZx4jGrVIevzMslvVbKzipzDzHWnbtOjeZCI8=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator ];
  buildInputs = [ soundtouch ];

  meta = {
    description =
      "Bindings for the soundtouch library which provides functions for changing pitch and timestretching audio data";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
