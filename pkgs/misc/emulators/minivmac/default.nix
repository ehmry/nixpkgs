{ stdenv, fetchurl, alsaLib, xlibsWrapper, xorgproto }:

stdenv.mkDerivation rec {
  pname = "minivmac";
  version = "36.04";

  src = fetchurl {
    url =
      "https://www.gryphel.com/d/minivmac/minivmac-${version}/minivmac-${version}.src.tgz";
    sha256 = "m3NDzsh3Ixd6ID5prTuvIPSbTo8DYZ42bEvycFFn36Q=";
  };

  buildInputs = [ alsaLib xlibsWrapper xorgproto ];

  preConfigure = ''
    $CC setup/tool.c -o setup_t
    echo "#!$SHELL" > configure
    ./setup_t -t lx64 >> configure
    chmod +x configure
  '';

  installPhase = "install -Dt $out/bin minivmac";

  postFixup = ''
    patchelf --set-rpath "${alsaLib}/dev":$(patchelf --print-rpath $out/bin/minivmac) $out/bin minivmac
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.gryphel.com/c/minivmac/";
    license = licenses.gpl2;
  };
}
