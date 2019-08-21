{ stdenv, fetchgit, fetchurl, bison, flex, glibc }:

let
  upstream = fetchgit
    { url = "git://depot.h4ck.me/srv/git/genode";
      rev = "edb117c13b0cde38ba66ffaaa19a798fbb6d044d";
      sha256 = "0rkpsh07hdv4r5pgyw707zhv546h96c6h150cdw01hi54jq8c0dr";
      fetchSubmodules = false;
    };

  inherit (stdenv) hostPlatform;

  archInfo =
    if hostPlatform.isAarch32 then { inherit (hostPlatform) isArm isAarch32; } else
    if hostPlatform.isAarch64 then { inherit (hostPlatform) isArm isAarch64; } else
    if hostPlatform.isx86_32  then { inherit (hostPlatform) isx86 isx86_32;  } else
    if hostPlatform.isx86_64  then { inherit (hostPlatform) isx86 isx86_64;  } else
    { };
in
stdenv.mkDerivation (archInfo // {
  name = "genodelibc-12.0.0";
  outputs = [ "out" "dev" ];

  builder = ./libc-builder.sh;

  depsBuildBuild =
    [ bison flex
      glibc # provides rpcgen
    ];

  src = fetchurl
    { url = "http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/12.0-RELEASE/src.txz";
      sha256 = "0da393ac2174168a71c1c527d1453e07372295187d05c288250800cb152a889b";
    };

  unpackPhase = "tar xf $src $tarFlags";

  tarFlags =
    [ "--strip-components=2"
      "usr/src/contrib/gdtoa"
      "usr/src/contrib/libc-vis"
      "usr/src/contrib/tzcode/stdtime"
      "usr/src/include"
      "usr/src/lib/libc"
      "usr/src/lib/msun"
      "usr/src/sys/amd64"
      "usr/src/sys/arm"
      "usr/src/sys/arm64"
      "usr/src/sys/bsm"
      "usr/src/sys/crypto/chacha20"
      "usr/src/sys/i386"
      "usr/src/sys/libkern"
      "usr/src/sys/net"
      "usr/src/sys/netinet"
      "usr/src/sys/netinet6"
      "usr/src/sys/riscv"
      "usr/src/sys/rpc"
      "usr/src/sys/sys"
      "usr/src/sys/vm"
      "usr/src/sys/x86"
      ];

  patches = "${upstream}/repos/libports/src/lib/libc/patches/*.patch";
  patchFlags = "-p0 --strip 3";

  libcPcIn = ./libc.pc.in;
  libcSymbols = ./libc.symbols;
})
