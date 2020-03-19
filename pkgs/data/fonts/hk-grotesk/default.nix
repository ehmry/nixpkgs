{ lib, fetchzip }:

let
  pname = "hk-grotesk";
  version = "2.42";
in fetchzip {
  name = "${pname}-${version}";

  url =
    "https://fontlibrary.org/assets/downloads/${pname}/feb28e2b4e7f37415d136fba0c1bc691/${pname}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype,woff,woff2}
    unzip -j $downloadedFile 'HK*.otf' \
      -d $out/share/fonts/opentype
    unzip -j $downloadedFile 'HK*.ttf' \
      -d $out/share/fonts/truetype
    unzip -j $downloadedFile 'HK*.woff' \
      -d $out/share/fonts/woff/
    unzip -j $downloadedFile 'HK*.woff2' \
      -d $out/share/fonts/woff2/
  '';

  hash = "sha256-si2HmWLLDCsrcfjxyBdS9/hGZExkcm3oFlmRmRBnlHc=";

  meta = with lib; {
    homepage = "https://hanken.co/products/hk-grotesk";
    description = "Sans serif typeface inspired by the classic grotesques";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.ehmry ];
  };
} // {
  inherit pname version;
}
