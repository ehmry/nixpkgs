{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, lame  }:

buildDunePackage rec {
  pname = "lame";
  version = "0.3.4";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-bZ4Syf71/rvqyeac5cFQrA2wIy+gbiWIkHynf57npRE=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ lame ];

  meta = {
    description = "MP3 encoding library";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
