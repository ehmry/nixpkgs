{ lib
, buildNimPackage
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
, unstableGitUpdater
}:

buildNimPackage (finalAttrs: prevAttrs: {
  pname = "nitter";
  version = "unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "d7ca353a55ea3440a2ec1f09155951210a374cc7";
    hash = "sha256-nlpUzbMkDzDk1n4X+9Wk7+qQk+KOfs5ID6euIfHBoa8=";
  };

  lockFile = ./lock.json;

  patches = [
    (substituteAll {
      src = ./nitter-version.patch;
      inherit (finalAttrs) version;
      inherit (finalAttrs.src) rev;
      url = builtins.replaceStrings [ "archive" ".tar.gz" ] [ "commit" "" ] finalAttrs.src.url;
    })
  ];

  postBuild = ''
    nim compile ${toString finalAttrs.nimFlags} -r tools/gencss
    nim compile ${toString finalAttrs.nimFlags} -r tools/rendermd
  '';

  postInstall = ''
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
  '';

  passthru = {
    tests = { inherit (nixosTests) nitter; };
    updateScript = unstableGitUpdater {};
  };

  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };
})
