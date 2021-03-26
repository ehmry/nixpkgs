{ ocamlPackages }:

let
  mirageOcamlPackages = ocamlPackages.overrideScope'
    (self: super: {
      buildMirageUnikernel = self.callPackage ../build-support/mirageos/default.nix { };

      mirage-crypto = super.mirage-crypto.override {
        withFreestanding = true;
      };

      tcpip = super.tcpip.override {
        withFreestanding = true;
      };
    });

in

# unikernels don't depend on each other, so don't create a new scope for now.
# Reusable components (i. e. libraries) go into ocamlPackages.
with mirageOcamlPackages;

{
    inherit (callPackage ../os-specific/mirageos/roburio-unikernels { })
      stub-resolver
      ;
}
