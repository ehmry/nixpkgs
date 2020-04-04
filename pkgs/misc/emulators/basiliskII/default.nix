{ stdenv, fetchFromGitHub, autoreconfHook, autoconf, automake, libtool, m4, gtk2
, pkgconfig, SDL, vde2 }:

stdenv.mkDerivation {
  pname = "basiliskII";
  version = "2020-03-15";

  src = fetchFromGitHub {
    owner = "cebix";
    repo = "macemu";
    rev = "a4a2c88ed7d13df0d16c3f8a737fc06f329b70cc";
    hash = "sha256-GlAJ0wEuGN8fqzrUVOkya4yQrQcZwjGO1BHWtgIqs4M=";
  };

  nativeBuildInputs = [ autoconf automake libtool m4 pkgconfig ];
  buildInputs = [ gtk2 SDL vde2 ];

  sourceRoot = "source/BasiliskII/src/Unix";

  preConfigure = "NO_CONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--disable-gtktest"
    "--disable-jit-compiler"
    "--disable-vosf"
    "--enable-sdl-audio"
    "--enable-sdl-video"
    "--with-bincue"
    "--with-gtk"
    "--with-libvhd"
    "--with-vdeplug"
    "--with-x"
  ];

  # Ⅱ
}
