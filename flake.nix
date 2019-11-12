{
  epoch = 201909;

  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let

      lib = import ./lib;

      jobs = import ./pkgs/top-level/release.nix { nixpkgs = self; };

      systems = [ "x86_64-linux" "x86_64-genode" ];

      forAllSystems = f: lib.genAttrs systems (system: f system);

    in {
      inherit lib;

      legacyPackages = forAllSystems (system:
        import ./. {
          localSystem = "x86_64-linux";
          crossSystem = system;
        });
    };
}
