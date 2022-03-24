{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, unzip, alsa-lib, libGL
, libpulseaudio, libuuid, nas, openssl, pango, sndio, xorg }:

let
  versionA = "6.0alpha";
  versionB = "21485";
  versionC = "202112201228";
in stdenv.mkDerivation rec {
  pname = "squeak";
  version = "${versionA}-${versionB}-${versionC}";

  src = fetchurl {
    url =
      "http://files.squeak.org/trunk/Squeak${versionA}-${versionB}-64bit/Squeak${versionA}-${versionB}-64bit-${versionC}-Linux-x64.tar.gz";
    sha256 = "sha256-4E32VJaZyQlE71Z98woiMX5shbaj6/cS0i7uloABANU=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper unzip ];

  buildInputs = with xorg; [
    alsa-lib
    libGL
    libICE
    libSM
    libX11
    libXext
    libXrender
    libpulseaudio
    libuuid
    nas
    pango
    sndio
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a bin $out/lib
    cp -a shared/* $out/lib
    makeWrapper $out/lib/squeak $out/bin/squeak \
      --prefix LD_LIBRARY_PATH ":" "$out/lib:${
        lib.makeLibraryPath [ openssl ]
      }" \
      --set SQUEAK_IMAGE $out/lib/Squeak${versionA}-${versionB}-64bit.image
  '';

  preFixup = ''
    patchelf $out/lib/vm-sound-sndio.so \
      --replace-needed libsndio.so.6.1 libsndio.so
  '';
  meta = {
    description = "Squeak virtual machine and image";
    homepage = "https://squeak.org/";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = [ "x86_64-linux" ];
  };
}
