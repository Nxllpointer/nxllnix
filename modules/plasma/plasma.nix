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

        Effect-overview.BorderActivate = "";
      };

      kactivitymanagerdrc = {
        activities = {
          b5640d09-faba-4fa5-a878-9379272d649a = "Default";
        };
      };

      "plasma-org.kde.plasma.desktop-appletsrc" = {
        Containments."1" = rec {
          activityId = "b5640d09-faba-4fa5-a878-9379272d649a";
          formfactor = 0;
          immutability = 1;
          lastScreen = 0;
          location = 0;
          plugin = "org.kde.plasma.folder";
          wallpaperplugin = "org.kde.image";
          ItemGeometriesHorizontal = "Applet-11101:0,0,256,480,0;Applet-11102:256,0,256,208,0;Applet-11103:256,208,256,272,0;";
          ItemGeometries-3840x2160 = ItemGeometriesHorizontal;

          Applets = {
            "11101".plugin = "org.kde.plasma.systemmonitor.cpucore";
            "11102".plugin = "org.kde.plasma.systemmonitor.memory";
            "11103".plugin = "org.kde.plasma.systemmonitor.diskusage";
          };
        };

        Containments."2" = {
          activityId = "";
          formfactor = 2;
          immutability = 1;
          lastScreen = 0;
          location = 4;
          plugin = "org.kde.panel";

          Applets = {
            "22201".plugin = "org.kde.plasma.kickoff";
            "22202".plugin = "org.kde.plasma.pager";
            "22203".plugin = "org.kde.plasma.icontasks";
            "22204".plugin = "org.kde.plasma.marginsseparator";
            "22205".plugin = "org.kde.plasma.systemtray";
            "22206" = {
              plugin = "org.kde.plasma.digitalclock";
              Configuration.Appearance.use24hFormat = 2;
            };
            "22207".plugin = "org.kde.plasma.showdesktop";
          };

          General.AppletOrder = "22201;22202;22203;22204;22205;22206;22207";
        };
      };

      plasmashellrc = {
        PlasmaViews."Panel 2".Defaults.thickness = 46;
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
