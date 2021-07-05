{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, ogg, libvorbis }:

buildDunePackage rec {
  pname = "vorbis";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-iCoE7I70wAp4n4XfETVKeaob2811E97/e6144bY/nqk=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libvorbis ];

  meta = {
    description = "Bindings to libvorbis";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
