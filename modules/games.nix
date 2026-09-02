{config, ...}: {
  configuration = {
    lib,
    globalconfig,
    ...
  }: {
    nixos = {
      programs.steam.enable = true;
    };

    home = {pkgs, ...}: {
      home.packages = with pkgs; [
        config.flake.packages.${stdenv.hostPlatform.system}.rhythia
        osu-lazer-bin
      ];

      programs.prismlauncher.enable = true;

      persisted.directories = lib.mkIf globalconfig.impermanence.enable [
        ".local/share/SoundSpacePlus"
        ".local/share/osu"
        ".local/share/PrismLauncher"
        ".local/share/Steam"
        ".steam"
      ];
    };
  };
}
