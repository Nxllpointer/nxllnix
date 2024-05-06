{
  description = "Nxllpointer's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let

      inherit (nixpkgs) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      configurationNames =
        builtins.attrNames (builtins.readDir ./configurations);

      createConfigurations = args:
        builtins.listToAttrs (builtins.map (configurationName: {
          name = configurationName;
          value = args {
            name = configurationName;
            path = ./configurations + "/${configurationName}";
          };
        }) configurationNames);

      evalProfile = profileName:
        (lib.evalModules {
          modules = [ (./profiles + "/${profileName}") ./modules/profile ];
        }).config;

    in {
      inputSet = inputs;
      nixosConfigurations = createConfigurations ({ name, path, }:
        let
          configuration = import path;
          profileName = configuration.profile;
          module = configuration.module;
          profile = evalProfile profileName;
        in lib.nixosSystem {
          modules = [ module ./modules/system ];
          specialArgs = {
            inherit (self) inputs;
            inherit profile;
          };
        });

      formatter =
        forAllSystems (system: (import nixpkgs { inherit system; }).nixfmt);
    };
}
