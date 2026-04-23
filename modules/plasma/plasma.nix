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
    pkgs,
    lib,
    ...
  }: {
    qt.kde.settings = {
      kglobalshortcutsrc = {
        services."org.kde.konsole.desktop"._launch = "Meta+T";
        kwin."Edit Tiles" = "none,Meta+T,Toggle Tiles Editor";

        services."firefox.desktop"._launch = "Meta+F";
      };

      kdeglobals = {
        KDE.AnimationDurationFactor = 0; # Instant animations
      };
    };

    home.activation.plasmaTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-lookandfeel -platform offscreen -a org.kde.breezedark.desktop
    '';
  };

  flake.modules.homeManager.impermanence = {
    persisted = {
      files = [
        ".config/kwinoutputconfig.json"
      ];
    };
  };
}
