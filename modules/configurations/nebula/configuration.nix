{config, ...}: {
  configurations.nixos.nxllnix-nebula.module = {
    imports = [
      ./_hardware-configuration.nix
      config.flake.modules.nixos.impermanence
      config.flake.modules.nixos.nvidia
    ];

    system.stateVersion = "25.11";

    nxllnix = {
      hostname = "nxllnix-nebula";
    };
  };
}
