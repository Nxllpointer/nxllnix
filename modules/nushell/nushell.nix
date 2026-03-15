{
  flake.modules.homeManager.base = {pkgs, ...}: {
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
  };
  flake.modules.nixos.base = {pkgs, ...}: {
    users.defaultUserShell = pkgs.nushell;

    # Enable completion scripts
    programs.fish.enable = true;
    programs.zsh.enable = true;
  };
}
