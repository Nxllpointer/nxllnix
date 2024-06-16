{
  description = "Nxllpointer's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
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

    in {
      inputSet = inputs;
      nixosConfigurations = createConfigurations ({ name, path, }:
        let
        in lib.nixosSystem {
          modules = [ path ./modules/system ];
          specialArgs = { inherit (self) inputs; };
        });

      formatter = forAllSystems
        (system: (import nixpkgs { inherit system; }).nixfmt-classic);
    };
}
