{
  configurations.nxllnix-nebula = {
    system = "x86_64-linux";
    impermanence.enable = true;
    gui.enable = true;

    update-command = "nix flake update --flake /home/nxll/Documents/nxllnix";
    rebuild-command = "sudo nixos-rebuild switch --flake /home/nxll/Documents/nxllnix --override-input extra-modules path:/home/nxll/Documents/nxllnix-extra/extra-modules";

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
