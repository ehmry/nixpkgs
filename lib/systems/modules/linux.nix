{ platform, abis, kernels, ... }:

let
  f = { isLinux ? false, ... }:
    if isLinux then {
      uname.system = "Linux";
      isUnix = true;
      kernel = kernels.linux;
      abi = platform.abi ? abis.gnu;
      libc = platform.libc ? "glibc";
    } else { };
in f platform
