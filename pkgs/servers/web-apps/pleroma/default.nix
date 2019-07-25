{ stdenv
, pkgs
, lib
, buildMix
, fetchgit
, git
, ... }:

buildMix rec {
  name    = "pleroma";
  version = "1.0.1";

  src = fetchgit {
    url = "https://git.pleroma.social/pleroma/pleroma.git/";
    rev = "5cb37412a21420509f61027fe486ae66242f800a";
    sha256 = "0kykmxfcf8mf8911sjn240hf49yf0jmv3x37g069km1mgwcs5djh";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ git ];
  
  postPatch = "touch $sourceRoot/config/prod.secret.exs";

  meta = with lib; {
    homepage        = "https://git.pleroma.social";
    maintainer      = [ maintainers.matthiasbeyer ];
    license         = stdenv.lib.licenses.agpl3;
    description     = "microblogging server software";
    longDescription = ''
      Pleroma is a microblogging server software that can federate (= exchange
      messages with) other servers that support the same federation standards
      (OStatus and ActivityPub). What that means is that you can host a server
      for yourself or your friends and stay in control of your online identity,
      but still exchange messages with people on larger servers. Pleroma will
      federate with all servers that implement either OStatus or ActivityPub,
      like Friendica, GNU Social, Hubzilla, Mastodon, Misskey, Peertube, and
      Pixelfed.

      Pleroma is written in Elixir, high-performance and can run on small
      devices like a Raspberry Pi.
    '';
  };
}
