# https://nim-lang.github.io/Nim/packaging.html

{ stdenv, lib, fetchgit, fetchurl, makeWrapper, gdb, openssl, pcre, readline
, boehmgc, sqlite, nim-unwrapped, nim-stdlib, nim }:

let
  meta = with lib; {
    description = "Statically typed, imperative programming language";
    homepage = "https://nim-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry ];
  };

  parseCpu = platform:
    with platform;
    # Derive a Nim CPU identifier
    if isAarch32 then
      "arm"
    else if isAarch64 then
      "arm64"
    else if isAlpha then
      "alpha"
    else if isAvr then
      "avr"
    else if isMips && is32bit then
      "mips"
    else if isMips && is64bit then
      "mips64"
    else if isMsp430 then
      "msp430"
    else if isPowerPC && is32bit then
      "powerpc"
    else if isPowerPC && is64bit then
      "powerpc64"
    else if isRiscV && is64bit then
      "riscv64"
    else if isSparc then
      "sparc"
    else if isx86_32 then
      "i386"
    else if isx86_64 then
      "amd64"
    else
      abort "no Nim CPU support known for ${config}";

  parseOs = platform:
    with platform;
    # Derive a Nim OS identifier
    if isAndroid then
      "Android"
    else if isDarwin then
      "MacOSX"
    else if isFreeBSD then
      "FreeBSD"
    else if platform.isGenode then
      "Genode"
    else if isLinux then
      "Linux"
    else if isNetBSD then
      "NetBSD"
    else if isNone then
      "Standalone"
    else if isOpenBSD then
      "OpenBSD"
    else if isWindows then
      "Windows"
    else if isiOS then
      "iOS"
    else
      abort "no Nim OS support known for ${config}";

  parsePlatform = p: {
    cpu = parseCpu p;
    os = parseOs p;
  };

  nimHost = parsePlatform stdenv.hostPlatform;
  nimTarget = parsePlatform stdenv.targetPlatform;

  version = "1.2.6";
  src = fetchurl {
    url = "https://nim-lang.org/download/nim-${version}.tar.xz";
    sha256 = "0zk5qzxayqjw7kq6p92j4008g9bbyilyymhdc5xq9sln5rqym26z";
  };

  wrapperInputs = rec {

    bootstrap = stdenv.mkDerivation rec {
      pname = "nim-bootstrap";
      version = "0.20.0";

      src = fetchgit {
        # A Git checkout is much smaller than a GitHub tarball.
        url = "https://github.com/nim-lang/csources.git";
        rev = "v" + version;
        sha256 = "0i6vsfy1sgapx43n226q8m0pvn159sw2mhp50zm3hhb9zfijanis";
      };

      enableParallelBuilding = true;

      installPhase = ''
        runHook preInstall
        install -Dt $out/bin bin/nim
        runHook postInstall
      '';
    };

    unwrapped = stdenv.mkDerivation {
      # https://nim-lang.github.io/Nim/packaging.html
      pname = "nim-unwrapped";
      inherit version src;

      buildInputs = [ boehmgc openssl pcre readline sqlite ];

      patches = [
        ./NIM_CONFIG_DIR.patch
        # Override compiler configuration via an environmental variable

        ./nixbuild.patch
        # Load libraries at runtime by absolute path
      ];

      configurePhase = ''
        runHook preConfigure
        cp ${bootstrap}/bin/nim bin/
        echo 'define:nixbuild' >> config/nim.cfg
        runHook postConfigure
      '';

      kochArgs = [
        "--cpu:${nimHost.cpu}"
        "--os:${nimHost.os}"
        "-d:release"
        "-d:useGnuReadline"
      ] ++ lib.optional (stdenv.isDarwin || stdenv.isLinux)
        "-d:nativeStacktrace";

      buildPhase = ''
        runHook preBuild
        local HOME=$TMPDIR
        ./bin/nim c koch
        ./koch boot $kochArgs --parallelBuild:$NIX_BUILD_CORES
        ./koch tools $kochArgs --parallelBuild:$NIX_BUILD_CORES
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dt $out/bin bin/*
        runHook postInstall
      '';

      inherit meta;
    };

    stdlib = stdenv.mkDerivation {
      pname = "nim-stdlib";
      inherit (nim-unwrapped) version src patches;
      preferLocalBuild = true;

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        touch bin/nim
        ./install.sh $TMPDIR
        cp -r $TMPDIR/nim/lib $out
        runHook postInstall
      '';

      meta = meta // {
        description = meta.description + " (standard library)";
      };
    };
  };

  wrapped = let
    nim = nim-unwrapped;
    inherit (stdenv) hostPlatform targetPlatform;
  in stdenv.mkDerivation {
    name = "${targetPlatform.config}-nim-wrapper-${nim.version}";
    inherit (nim) version;
    preferLocalBuild = true;

    nativeBuildInputs = [ makeWrapper ];

    unpackPhase = ''
      runHook preUnpack
      tar xf ${nim.src} nim-$version/config/nim.cfg
      cd nim-$version
      runHook postUnpack
    '';

    patches = [ ./nim.cfg.patch ];

    dontConfigure = true;
    dontBuild = true;

    targetOs = nimTarget.os;
    targetCpu = nimTarget.cpu;
    ccKind = with stdenv;
      if cc.isGNU then
        "gcc"
      else if cc.isClang then
        "clang"
      else
        abort "no Nim configuration available for ${cc.name}";
    # env-vars used by substituteAll

    wrapperArgs = [
      ''--suffix PATH : "${lib.makeBinPath [ stdenv.cc gdb ]}:${placeholder "out"}/bin"''
      ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.libc ]}"''
      "--set NIM_CONFIG_PATH ${placeholder "out"}/etc/nim"
    ];

    installPhase =
      # Fortify hardening appends -O2 to gcc flags which is unwanted for unoptimized nim builds.
      ''
        runHook preInstall

        mkdir -p $out/bin $out/etc/nim
        substituteAll config/nim.cfg $out/etc/nim/nim.cfg

        for binpath in ${nim}/bin/nim?*; do
          local binname=`basename $binpath`
          makeWrapper $binpath $out/bin/${targetPlatform.config}-$binname \
            $wrapperArgs
          ln -s $out/bin/${targetPlatform.config}-$binname $out/bin/$binname
        done

        makeWrapper ${nim}/bin/nim $out/bin/${targetPlatform.config}-nim \
          $wrapperArgs \
          --set NIX_HARDENING_ENABLE "''${NIX_HARDENING_ENABLE/fortify}" \
          --add-flags --lib:${nim-stdlib}
        ln -s $out/bin/${targetPlatform.config}-nim $out/bin/nim

        runHook postInstall
      '';

    meta = meta // {
      description = nim.meta.description
        + " (${nim.target.os}-${nim.target.cpu} wrapper)";
      platforms = lib.platforms.unix;
    };

  };

in wrapped // wrapperInputs
