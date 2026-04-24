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

      kwinrc = {
        Desktops = {
          Id_1 = "d40ae7d8-76a1-47ce-84f6-73ca391f3e5e";
          Id_2 = "e5134201-07bc-4f78-b68e-800f44bcd04d";
          Id_3 = "c9f53370-9829-4193-876e-9eeca5f17f82";
          Id_4 = "337f3589-e9b5-4454-a08a-21bb710fdd3c";
          Id_5 = "19dec7d0-138a-4468-84c5-52c64e4b500f";
          Number = 5;
          Rows = 1;
        };
      };

      konsolerc = {
        "Notification Messages".CloseAllTabs = true;
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
