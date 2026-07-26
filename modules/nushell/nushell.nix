{
  configuration = {
    lib,
    globalconfig,
    ...
  }: {
    nixos = {pkgs, ...}: {
      users.defaultUserShell = pkgs.nushell;

      # Enable completion scripts
      programs.fish.enable = true;
      programs.zsh.enable = true;
    };

    home = {pkgs, ...}: {
      home.shell.enableNushellIntegration = true;
      programs = {
        nushell = {
          enable = true;
          configFile.source = ./config.nu;
          environmentVariables = {
            STARSHIP_CONFIG = pkgs.starship + "/share/starship/presets/pastel-powerline.toml";
          };
        };
        carapace.enable = true;
        starship.enable = true;
        nix-your-shell = {
          enable = true;
          enableNushellIntegration = false; # Breaks completion scripts
        };
      };

      persisted.files = lib.mkIf globalconfig.impermanence.enable [".config/nushell/history.txt"];
    };
  };
}
