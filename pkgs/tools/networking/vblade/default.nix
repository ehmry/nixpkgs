{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "vblade";
  version = "24";
  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "OpenAoE";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-/8FsVJDbGaDJmnMLx6t/eRG65Xy4azl0MYef1gECX6o=";
  };

  dontConfigure = true;

  buildFlags = [
    "PLATFORM=${
      if stdenv.isLinux then
        "linux"
      else if stdenv.isFreeBSD then
        "freebsd"
      else
        throw "vblade not support on this platform"
    }"
    "vblade"
  ];

  installPhase = ''
    install -Dt "''${!outputBin}/bin" vblade
    install -Dt "''${!outputMan}/share/man/man8" vblade.8
  '';

  meta = with stdenv.lib;
    src.meta // {
      description = "Minimal userland AoE target";
      license = licenses.gpl2;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux ++ platforms.freebsd;
    };
}
