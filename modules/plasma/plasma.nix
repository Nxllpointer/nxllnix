{
  flake.modules.nixos.base = {pkgs, ...}: {
    services = {
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      desktopManager.plasma6.enable = true;
      xserver.enable = true;
    };
  };

  flake.modules.homeManager.gui = {pkgs, ...}: {
    home.packages = [pkgs.kdePackages.kzones];
    qt.kde.settings.kwinrc = {
      Script-kzones.layoutsJson = builtins.readFile ./kzones-layouts.json;
      Plugins.kzonesEnabled = true;
    };
  };
}
