{ lib, getdns, htslib, libsass, libui, libX11, libXft, libXinerama, pkg-config, tkrzw, openssl, SDL2 }:

# The following is list of overrides that take three arguments each:
# - lockAttrs: - an attrset from a Nim lockfile, use this for making constraints on the locked library
# - finalAttrs: - final arguments to the depender package
# - prevAttrs: - preceding arguments to the depender package
{
  jester = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ openssl ];
    };

  getdns = lockAttrs: finalAttrs:
    { nativeBuildInputs ? [ ], buildInputs ? [ ], ... }: {
      nativeBuildInputs = nativeBuildInputs ++ [ pkg-config ];
      buildInputs = buildInputs ++ [ getdns ];
    };

  hts = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ htslib ];
    };

  sass = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ libsass ];
    };


  sdl2 = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ SDL2 ];
    };

  tkrzw = lockAttrs: finalAttrs:
    { nativeBuildInputs ? [ ], buildInputs ? [ ], ... }: {
      nativeBuildInputs = nativeBuildInputs ++ [ pkg-config ];
      buildInputs = buildInputs ++ [ tkrzw ];
    };

  x11 = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ libX11 libXft libXinerama ];
    };

  zippy = lockAttrs: finalAttrs:
    { nimFlags ? [ ], ... }: {
      nimFlags = nimFlags ++ [ "--passC:-msse4.1" "--passC:-mpclmul" ];
    };
}
