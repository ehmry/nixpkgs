{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, ogg, speex }:

buildDunePackage rec {
  pname = "speex";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    hash = "sha256-KzWOrI11i3c9ZbNi2gsnhcsnXhaPec93R2m3jjgus5M=";
  };

  useDune2 = true;

  nativeBuildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg speex ];

  meta = {
    description = "Bindings to libspeex";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.ehmry ];
  };

}
