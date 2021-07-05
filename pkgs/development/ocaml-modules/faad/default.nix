{ lib, fetchFromGitHub, buildDunePackage, dune-configurator
, faad2
}:

buildDunePackage rec {
  pname = "faad";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-0oJapyYN1EFRNHa4STY9kpjJ05YKAjuMfCYt6f+bChk=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator ];
  buildInputs = [ faad2 ];

  meta = {
    description = "Bindings for the faad library which provides functions for decoding AAC audio files";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
