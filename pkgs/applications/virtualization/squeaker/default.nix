{ lib, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "squeaker";
  version = "unstable-2022-03-04";

  src = fetchFromGitHub {
    owner = "tonyg";
    repo = pname;
    rev = "caf2ef0b6d5c3cd211b966d3933d4baa885676b5";
    hash = "sha256-DXYKT3buaQ0WfebNwdGT3s2eAAKpndmZ3TczCD/alH0=";
  };

  propagatedBuildInputs = [

  ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin squeaker
    runHook postInstall
  '';

  meta = src.meta // {
    description = "Like Docker, but for Squeak";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
