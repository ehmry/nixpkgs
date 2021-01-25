{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ghfs";
  version = "unstable-2020-06-13";

  src = fetchFromGitHub {
    owner = "sirnewton01";
    repo = "ghfs";
    rev = "6c8fb3a0347c99b09b0b5fdbb8b282735414d68e";
    sha256 = "14a7kiwgw3z7jjfmq09mw2y7y511dc0978179vhfzy3dbrp78v6y";
  };

  vendorSha256 = "0av26bxx61jfbdl6d7mx8jdlvcd943n7pcjfhf306z595cpb50qj";

  meta = with lib;
    src.meta // {
      description =
        "9p GitHub filesystem written in Go for use with Plan 9/p9p";
      license = licenses.mit;
      maintainers = with maintainers; [ ehmry ];
    };
}
