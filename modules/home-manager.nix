{
  inputs,
  config,
  ...
}: let
  homeModules = config.flake.modules.homeManager;
in {
  flake.modules.nixos.base = {config, ...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.nxllnix.username} = {
        imports = [
          homeModules.base
          homeModules.gui
        ];
        home.stateVersion = config.system.stateVersion;
      };
    };
  };

  flake.modules.nixos.impermanence = {config, ...}: {
    home-manager.users.${config.nxllnix.username}.imports = [homeModules.impermanence];
  };
}
