{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, pkg-config
, ladspa-sdk }:

buildDunePackage rec {
  pname = "ladspa";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-ItGtv64GKv645ConLADSyhoQODNuC6QzBb+8TOG0k20=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator pkg-config ];
  buildInputs = [ ladspa-sdk ];

  meta = {
    description = "Bindings for the LADSPA API which provides audio effects";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
