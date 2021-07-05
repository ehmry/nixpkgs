{ lib, stdenv, makeWrapper, fetchurl, which, pkg-config, ocamlPackages, SDL
, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "liquidsoap";
  version = "1.4.4";

  src = fetchurl {
    url =
      "https://github.com/savonet/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-46oJg65t5RJhORNDlj6bmqhURMjk6R/ecWq8kkYqFxI=";
  };

  postFixup = ''
    wrapProgram $out/bin/liquidsoap \
      --set LIQ_LADSPA_PATH /run/current-system/sw/lib/ladspa
  '';

  # configureFlags = [ "--localstatedir=/var" ];

  nativeBuildInputs = [ makeWrapper pkg-config ]
    ++ (with ocamlPackages; [ menhir findlib ocaml ]);
  buildInputs = [
    SDL
    which
  ] ++ (with ocamlPackages; [
    ao
    camlimages
    camomile
    cry
    dtools
    duppy
    faad
    fdkaac
    ffmpeg
    flac
    frei0r
    inotify
    ladspa
    lame
    gstreamer
    mad
    menhirLib
    mm
    ocaml_pcre
    ogg
    opus
    pulseaudio
    samplerate
    sedlex_2
    soundtouch
    speex
    srt
    ssl
    vorbis
    xmlplaylist
    yojson
  ]) ++ (with pythonPackages; [ pygtk python ]);

  # hardeningDisable = [ "format" "fortify" ];

  meta = with lib; {
    description = "Swiss-army knife for multimedia streaming";
    homepage = "https://www.liquidsoap.info/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = ocamlPackages.ocaml.meta.platforms or [ ];
  };
}
