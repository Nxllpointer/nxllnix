{config, ...}: {
  configurations.nixos.nxllnix-nebula.module = {
    imports = [
      ./_hardware-configuration.nix
      ./_nvidia.nix
      config.flake.modules.nixos.impermanence
    ];

    system.stateVersion = "25.11";

    nxllnix = {
      hostname = "nxllnix-nebula";
    };
  };
}
