{inputs, ...}: {
  configuration = {globalconfig, ...}: {
    nixos = {config, ...}: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${globalconfig.username} = {
          imports = [globalconfig.home];
          home.stateVersion = config.system.stateVersion;
        };
      };
    };

    home = {
      home.username = globalconfig.username;
      home.homeDirectory = "/home/${globalconfig.username}";
    };
  };
}
