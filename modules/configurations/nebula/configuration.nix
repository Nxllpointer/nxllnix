{
  configurations.nxllnix-nebula = {
    system = "x86_64-linux";
    impermanence.enable = true;
    gui.enable = true;

    nixos = {
      imports = [
        ./_hardware-configuration.nix
        ./_nvidia.nix
      ];

      system.stateVersion = "26.05";
      hostname = "nxllnix-nebula";
    };

    home = {
      home.stateVersion = "26.05";
    };
  };
}
