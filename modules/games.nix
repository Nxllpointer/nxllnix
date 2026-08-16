{config, ...}: {
  configuration = {
    lib,
    globalconfig,
    ...
  }: {
    home = {pkgs, ...}: {
      home.packages = [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.rhythia
      ];

      programs.prismlauncher.enable = true;

      persisted.directories = lib.mkIf globalconfig.impermanence.enable [
        ".local/share/SoundSpacePlus"
        ".local/share/PrismLauncher"
      ];
    };
  };
}
