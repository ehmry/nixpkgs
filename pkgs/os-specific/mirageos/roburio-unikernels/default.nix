{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-2020-07-24";
  src = fetchFromGitHub {
    owner = "roburio";
    repo = "unikernels";
    rev = "1cd349fef3ffc4d3fbb51bd7d35421c8d8bb9671";
    sha256 = "194c2srcd02dh6dn5nxb31zy0np6km8rwa91jfk5935mkl5pwdh6";
  };

  meta = {
    inherit (src) homepage;
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  callPackage' = f: args:
    callPackage f ({
      inherit version src meta;
    } // args);

in {
  stub-resolver = callPackage' ./stub-resolver.nix { };
}
