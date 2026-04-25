{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.impermanence = {config, ...}: {
    imports = [
      inputs.impermanence.nixosModules.impermanence
      (lib.mkAliasOptionModule ["persisted"] ["environment" "persistence" "/persisted/"])
    ];

    persisted = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/lib/NetworkManager"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };

  flake.modules.homeManager.impermanence = {config, ...}: {
    imports = [(lib.mkAliasOptionModule ["persisted"] ["home" "persistence" "/persisted/"])];

    persisted = {
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Videos"
        "Music"
        ".ssh"
      ];
    };

    home.file = builtins.listToAttrs (
      map
      (dir: {
        name = "${dir.directory}/.directory";
        value = {
          text = ''
            [Desktop Entry]
            Icon=folder-orange
          '';
        };
      })
      config.persisted.directories
    );
  };
}
