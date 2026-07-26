{
  inputs,
  lib,
  ...
}: {
  configuration = {globalconfig, ...}: {
    options = {
      impermanence.enable = lib.mkEnableOption "impermanence";
    };
    config = {
      nixos = {
        imports = [
          inputs.impermanence.nixosModules.impermanence
          (lib.mkAliasOptionModule ["persisted"] ["environment" "persistence" "/persisted/"])
        ];

        persisted = lib.mkIf globalconfig.impermanence.enable {
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

      home = {config, ...}: {
        imports = [
          (lib.mkAliasOptionModule ["persisted"] ["home" "persistence" "/persisted/"])
        ];

        config = lib.mkIf globalconfig.impermanence.enable {
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
      };
    };
  };
}
