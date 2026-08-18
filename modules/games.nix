{config, ...}: {
  configuration = {
    lib,
    globalconfig,
    ...
  }: {
    home = {pkgs, ...}: {
      home.packages = with pkgs; [
        config.flake.packages.${stdenv.hostPlatform.system}.rhythia
        pkgs.osu-lazer-bin
      ];

      programs.prismlauncher.enable = true;

      persisted.directories = lib.mkIf globalconfig.impermanence.enable [
        ".local/share/SoundSpacePlus"
        ".local/share/osu"
        ".local/share/PrismLauncher"
      ];
    };
  };
}
