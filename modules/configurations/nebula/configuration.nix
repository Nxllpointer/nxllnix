{config, ...}: {
  configurations.nixos.nxllnix-nebula.module = {
    imports = [
      ./_hardware-configuration.nix
      ./_nvidia.nix
      config.flake.modules.nixos.impermanence
    ];

    system.stateVersion = "26.05";

    nxllnix = {
      hostname = "nxllnix-nebula";
    };
  };
}
