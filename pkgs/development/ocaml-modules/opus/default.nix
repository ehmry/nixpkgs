{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, ogg, libopus, pkg-config }:

buildDunePackage rec {
  pname = "opus";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-kuK9u9gufHBY7tijhge7bBKrvO7QqTbqiKef8YZ0gCI=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libopus pkg-config ];

  meta = {
    description = "Bindings to libopus";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
