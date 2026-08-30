{inputs, ...}: {
  configurations.nxllnix-orion = {
    system = "x86_64-linux";
    impermanence.enable = true;
    gui.enable = true;

    update-command = "nix flake update --flake /home/nxll/Documents/nxllnix";
    rebuild-command = "sudo nixos-rebuild switch --flake /home/nxll/Documents/nxllnix --override-input extra-modules path:/home/nxll/Documents/nxllnix-extra/extra-modules";

    nixos = {
      imports = [
        ./_hardware-configuration.nix
        inputs.corecycler.nixosModules.default
      ];

      # Make systemd-boot screen larger
      boot.loader.systemd-boot.consoleMode = "max";

      system.stateVersion = "26.05";
      hostname = "nxllnix-orion";

      services.corecycler = {
        enable = true;
        deviceAccessUser = "nxll";
      };
    };

    home = {pkgs, ...}: {
      home.stateVersion = "26.05";
      persisted.directories = [".local/share/corecycler"];

      home.packages = [
        (pkgs.mprime.overrideAttrs (prev: {
          src = prev.src.overrideAttrs (prevSrc: {
            urls = [
              (
                # .ca redirects to google drive and shows a popup
                builtins.replaceStrings
                ["https://download.mersenne.ca/gimps/"]
                ["https://www.mersenne.org/download/software/"]
                prev.src.url
              )
            ];
          });
        }))
      ];
    };
  };
}
