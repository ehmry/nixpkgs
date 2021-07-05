{ lib, fetchFromGitHub, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "cry";
  version = "0.6.5";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "${version}";
    hash = "sha256-g+m5l/IdjE+LkOfWUtp4XKcU+1+wfJXWRVsfIRmrmrw=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  # propagatedBuildInputs = [ ];

  meta = {
    description = "OCaml client for the various icecast & shoutcast source protocols";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
