let
  # KZones: Move active window to zone 1=Num+1,none,KZones: Move active window to zone 1
  kzonesMoveName = zone: "KZones: Move active window to zone ${zone}";
  kzonesKwinShortcuts = builtins.listToAttrs (
    map
    (zone: {
      name = kzonesMoveName zone;
      value = "Num+${zone},none,${kzonesMoveName zone}";
    })
    ["1" "2" "3" "4" "5" "6" "7" "8" "9"]
  );
in {
  flake.modules.homeManager.gui = {pkgs, ...}: {
    home.packages = [pkgs.kdePackages.kzones];

    qt.kde.settings.kwinrc = {
      Script-kzones.layoutsJson = builtins.readFile ./kzones-layouts.json;
      Plugins.kzonesEnabled = true;
    };

    qt.kde.settings.kglobalshortcutsrc = {
      kwin = kzonesKwinShortcuts;
    };
  };
}
