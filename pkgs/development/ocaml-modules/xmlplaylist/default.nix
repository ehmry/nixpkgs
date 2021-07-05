{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, xmlm }:

buildDunePackage rec {
  pname = "xmlplaylist";
  version = "0.1.5";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-mDmNixQ3vdOjCQr1jUaQ6XhvRkJ0Ob9RB+BGkSdftPQ=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ xmlm ];

  meta = {
    description = "Library to parse various file playlists in XML format";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
