{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, glib, gstreamer
, gst-plugins-base }:

buildDunePackage rec {
  pname = "gstreamer";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-UUp0qfp+XKasF8ZUSG3tWXqqE3TS2GXSzJA0CnCIHXk=";
  };

  useDune2 = true;

  buildInputs = [ dune-configurator glib gstreamer gst-plugins-base ];

  meta = {
    description =
      "Bindings for the GStreamer library which provides functions for playning and manipulating multimedia streams";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
