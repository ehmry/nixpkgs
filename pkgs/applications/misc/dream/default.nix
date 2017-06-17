{ stdenv, fetchurl, pkgconfig
, faac
, faad2
, fftw
, gpsd
, hamlib
, libopus
, libpcap
, libpulseaudio
, libsndfile
, libsForQt5
, qt5
, qwt
, speex
, zlib
}:

let version = "2.1.1"; in
stdenv.mkDerivation {
  name = "dream-" + version;

  src = fetchurl {
    url = "mirror://sourceforge/drm/dream/${version}/dream-${version}-svn808.tar.gz";
    sha256 = "01dv6gvljz64zrjbr08mybr9aicvpq2c6qskww46lngdjyhk8xs1";
  };

  buildInputs =
    [ faac
      faad2
      fftw
      gpsd
      hamlib
      libopus
      libpcap
      libpulseaudio
      libsForQt5.qwt
      libsndfile
      pkgconfig
      qt5.qmakeHook
      qt5.qtbase
      qt5.qtsvg
      qt5.qtwebkit
      speex
      zlib
    ];

  qmakeFlags = map (x: "CONFIG+="+x)
    [ "consoleio"
      "faac"
      "faad"
      "gps"
      "hamlib"
      "opus"
      "pcap"
      "qt5"
      "sndfile" 
      "speexdsp"
   ];

  postPatch =
    ''
      substituteInPlace dream.pro \
        --replace "path = /usr" "path = $out" \
        --replace "exists(\$\$OUT_PWD/include/neaacdec.h)" "faad" \
        --replace "faad_drm" "faad" \
        --replace "exists(\$\$OUT_PWD/include/faac.h)" "faac" \
        --replace "faac_drm" "faac" \
    '';

  meta = with stdenv.lib;
    { description = "Digital Radio Mondiale software receiver";
      license = licenses.gpl2;
      maintainers = [ maintainers.ehmry ];
    };
}
