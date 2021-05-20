{ lib, buildDunePackage, fetchFromGitHub, lwt_ppx, ppx_cstruct, optint
, checkseum, diet, bitv, nocrypto, logs, lru, io-page, mirage-block }:

buildDunePackage rec {
  pname = "wodan";
  version = "unstable-2020-10-21";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "mirage";
    repo = pname;
    rev = "4e9e7bf4209cc33e5415ae137c9156683878eada";
    sha256 = "sha256-pFoXmK6Aabc1lRzJQEMjuGnZb4bsDTXra2ToA6maUYg=";
    fetchSubmodules = true;
  };

  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    lwt_ppx
    ppx_cstruct
    optint
    checkseum
    diet
    bitv
    nocrypto
    logs
    lru
    io-page
    mirage-block
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A flash-friendly, safe and flexible filesystem library";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
