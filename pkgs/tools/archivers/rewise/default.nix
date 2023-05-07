{ lib, stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "rewise";
  version = "unstable-2023-05-04";
  src = fetchgit {
    url = "https://notabug.org/CYBERDEViL/REWise.git";
    rev = "ef725ba3b6bb81ca2fe0aa3d37e920cdbb429c20";
    hash = "sha256-ZL65QSEefMo4YqaZlECcjjuXiY8mQcfXsN1LZfo7kAg=";
  };
  installPhase = "install -Dt $out/bin rewise";
  meta = {
    description = "Extract files from Wise installers without executing them";
    homepage = "https://notabug.org/CYBERDEViL/REWise";
    license = lib.licenses.gpl2Only;
    maintains = with lib.maintainers; [ ehmry ];
  };
}
