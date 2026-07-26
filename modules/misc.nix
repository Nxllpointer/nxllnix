{
  config,
  lib,
  ...
}: {
  configuration = {globalconfig, ...}: {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [file];
    };

    home = {pkgs, ...}:
      lib.mkMerge [
        {
          programs = {
            btop.enable = true;
            bat.enable = true;
          };
        }
        (lib.mkIf globalconfig.gui.enable {
          programs = {
            vesktop.enable = true;
            vscode.enable = true;
            prismlauncher.enable = true;
          };

          services.flameshot.enable = true;

          home.packages = with pkgs; [
            libreoffice
            cameractrls-gtk4
            config.flake.packages.${pkgs.stdenv.hostPlatform.system}.rhythia
          ];

          persisted.directories = lib.mkIf globalconfig.impermanence.enable [
            ".config/vesktop"
            ".vscode"
            ".config/Code"
            ".local/share/PrismLauncher"
            ".local/share/SoundSpacePlus"
          ];
        })
      ];
  };
}
