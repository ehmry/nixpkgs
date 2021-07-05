{ lib, stdenv, fetchurl, fetchFromGitHub, buildDunePackage, ocaml, findlib
, dune-configurator, pkg-config, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "ffmpeg";
  version = "0.4.3";
  src = fetchurl {
    url =
      "https://github.com/savonet/ocaml-${pname}/releases/download/v${version}/ocaml-${pname}-${version}.tar.gz";
    hash = "sha256-j8Y9yalBv6Rau1/jl2PoLpkkogW/AVdjmF/um78YA6I=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator pkg-config ocaml findlib ];
  buildInputs = [ ffmpeg ];

  meta = {
    description =
      "Bindings for the ffmpeg library which provides functions for decoding audio and video files";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };
}
