{config, ...}: {
  flake.modules.nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [file];
  };

  flake.modules.homeManager.base = {
    programs = {
      btop.enable = true;
      bat.enable = true;
    };
  };

  flake.modules.homeManager.gui = {pkgs, ...}: {
    programs = {
      vesktop.enable = true;
      vscode.enable = true;
      prismlauncher.enable = true;
    };
    services = {
      flameshot.enable = true;
    };
    home.packages = with pkgs; [
      libreoffice
      cameractrls-gtk4
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.rhythia
    ];
  };
}
