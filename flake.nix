{
  epoch = 201909;

  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      lib = import ./lib;

      jobs = import ./pkgs/top-level/release.nix { nixpkgs = self; };

      localSystems = [ "x86_64-linux" ];

      forAllSystems = f: lib.genAttrs localSystems (system: f system);

      natives = forAllSystems (system: import ./. { inherit system; });

      crossSystems = [ "x86_64-genode" ];

      forAllCrossSystems = f:
        with builtins;
        let
          f' = localSystem: crossSystem:
            let system = localSystem + "-" + crossSystem;
            in {
              name = system;
              value = f { inherit system localSystem crossSystem; };
            };
          list = lib.lists.crossLists f' [ localSystems crossSystems ];
        in listToAttrs list;

      crossPairs = forAllCrossSystems ({ system, localSystem, crossSystem }:
        import ./. {
          inherit localSystem crossSystem;
          config.allowUnsupportedSystem = localSystem != crossSystem;
        });

    in {
      lib = lib // { inherit forAllSystems forAllCrossSystems; };
      legacyPackages = natives // crossPairs;
    };
}
