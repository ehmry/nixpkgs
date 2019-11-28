# SPDX-FileCopyrightText: Emery Hemingway
#
# SPDX-License-Identifier: LicenseRef-Hippocratic-1.1

{ stdenvNoCC, lib, fetchurl }:

let
  stdenv = stdenvNoCC;
  version = "19.11";
  platform = stdenv.targetPlatform;
in stdenv.mkDerivation {
  pname = platform.system + "-headers";
  inherit version;

  src = fetchurl {
    url = "https://github.com/genodelabs/genode/archive/${version}.tar.gz";
    sha256 = "0ll7wdglx6c1zx7rdbhxy8gpcfipy22q0agwrf8ch7nk9ngmgm3r";
  };

  specs = with platform; []
    ++ lib.optional is32bit "32bit"
    ++ lib.optional is64bit "64bit"
    ++ lib.optional isAarch32 "arm"
    ++ lib.optional isAarch64 "arm_64"
    ++ lib.optional isRiscV "riscv"
    ++ lib.optional isx86 "x86"
    ++ lib.optional isx86_32 "x86_32"
    ++ lib.optional isx86_64 "x86_64";

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup

    tar fx $src \
        --strip-components=2 \
        genode-$version/repos/base/include \
        genode-$version/repos/demo/include \
        genode-$version/repos/gems/include \
        genode-$version/repos/libports/include \
        genode-$version/repos/os/include \
        genode-$version/repos/ports/include \

    includeDir=$out/include
    mkdir -p $includeDir

    for DIR in */include; do
        for SPEC in $specs; do
          if [ -d $DIR/spec/$SPEC ]; then
              cp -r $DIR/spec/$SPEC/* $includeDir/
              rm -r $DIR/spec/$SPEC
          fi
        done
        rm -rf $DIR/spec
        cp -r $DIR/* $includeDir
    done
  '';
}
