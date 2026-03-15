{inputs, ...}: {
  flake.modules.nixos.impermanence = {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence."/persisted" = {
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

  flake.modules.homeManager.impermanence = let
    persistedDirs = [
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"
      "Music"
      ".ssh"
    ];
  in {
    home.persistence."/persisted" = {
      directories = persistedDirs;
    };

    home.file = builtins.listToAttrs (
      map
      (dir: {
        name = "${dir}/.directory";
        value = {
          text = ''
            [Desktop Entry]
            Icon=folder-orange
          '';
        };
      })
      persistedDirs
    );
  };
}
