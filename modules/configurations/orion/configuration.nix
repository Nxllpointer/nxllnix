{
  configurations.nxllnix-orion = {
    system = "x86_64-linux";
    impermanence.enable = true;
    gui.enable = true;

    update-command = "nix flake update --flake /home/nxll/Documents/nxllnix";
    rebuild-command = "sudo nixos-rebuild switch --flake /home/nxll/Documents/nxllnix --override-input extra-modules path:/home/nxll/Documents/nxllnix-extra/extra-modules";

    nixos = {
      imports = [
        ./_hardware-configuration.nix
      ];

      # Make systemd-boot screen larger
      boot.loader.systemd-boot.consoleMode = "max";

      system.stateVersion = "26.05";
      hostname = "nxllnix-orion";
    };

    home = {
      home.stateVersion = "26.05";
    };
  };
}
