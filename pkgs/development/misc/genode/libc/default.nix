{ stdenv, fetchgit, fetchurl, bison, flex, glibc }:

let
  archInfo = let inherit (stdenv) hostPlatform;
  in if hostPlatform.isAarch32 then {
    inherit (hostPlatform) isArm isAarch32;
  } else if hostPlatform.isAarch64 then {
    inherit (hostPlatform) isArm isAarch64;
  } else if hostPlatform.isx86_32 then {
    inherit (hostPlatform) isx86 isx86_32;
  } else if hostPlatform.isx86_64 then {
    inherit (hostPlatform) isx86 isx86_64;
  } else
    { };
in stdenv.mkDerivation (archInfo // {
  name = "genodelibc-12.0.0";
  outputs = [ "out" "dev" ];

  builder = ./libc-builder.sh;

  depsBuildBuild = [
    bison
    flex
    glibc # provides rpcgen
  ];

  src = fetchurl {
    url =
      "http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/12.0-RELEASE/src.txz";
    sha256 = "0da393ac2174168a71c1c527d1453e07372295187d05c288250800cb152a889b";
  };

  unpackPhase = "tar xf $src $tarFlags";

  tarFlags = [
    "--strip-components=2"
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

  patches = [
    ./cdefs_no_hidden.patch
    ./_CurrentRuneLocale.patch
    ./gdtoa.patch
    ./log2.patch
    ./MB_CUR_MAX.patch
    ./mktime.patch
    ./printfcommon.patch
    ./rcmd.patch
    ./res_init_c.patch
    ./runetype.patch
    ./semaphore.patch
    ./thread_local.patch
    ./types.patch
    ./vfwprintf_c_warn.patch
    ./xlocale.patch
    ./xlocale_private.patch
    ./xprintf_float.patch
  ];

  patchFlags = "-p0 --strip 3";

  ldScriptSo = ./genode_rel.ld;

  libcPcIn = ./libc.pc.in;
  libcSymbols = ./libc.symbols;
})
