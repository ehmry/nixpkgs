{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, libsamplerate }:

buildDunePackage rec {
  pname = "samplerate";
  version = "0.1.5";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-ENOx9Xe4N7HzGKDCBk59GiH16tTJ6Kp7PNeZ+JcKHXg=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator ];
  buildInputs = [ libsamplerate ];

  meta = {
    description = "Samplerate audio conversion library";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
