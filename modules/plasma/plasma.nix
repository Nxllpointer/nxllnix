{
  flake.modules.nixos.base = {pkgs, ...}: {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
      desktopManager.plasma6.enable = true;
      xserver.enable = true;
    };
  };

  flake.modules.homeManager.gui = {
    qt.kde.settings.kglobalshortcutsrc = {
      services."org.kde.konsole.desktop"._launch = "Meta+T";
      kwin."Edit Tiles" = "none,Meta+T,Toggle Tiles Editor";
    };
  };

  flake.modules.homeManager.impermanence = {
    persisted = {
      files = [
        ".config/kwinoutputconfig.json"
      ];
    };
  };
}
