{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, libogg }:

buildDunePackage rec {
  pname = "ogg";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-7+UZLiW5P2LEgcJxN4d8tTV1XaoHeNgjt9LuWtdG/Ak=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libogg ];

  meta = {
    description = "Bindings to libogg";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
