let
  f = { isx86_32 ? false, isx86_64 ? false, ... }:
    if (isx86_32 || isx86_64) then {
      isx86 = true;

      isLittleEndian = true;
      isi686 = isx86_32;
      is32bit = isx86_32;
      is64bit = isx86_64;
      uname.processor = if isx86_32 then "i686" else "x86_64";
      cpu = if isx86_64 then {
        arch = "x86-64";
        bits = 64;
        family = "x86";
        name = "x86_64";
        significantByte.name = "littleEndian";
      } else null;
    } else
      { };
in { platform, ... }: f platform
