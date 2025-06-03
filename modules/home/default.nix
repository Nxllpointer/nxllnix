{
  imports = [
    ./git.nix
    ./shell
  ];

  home.stateVersion = "24.05";

  qt.kde.settings.kwinrc = {
    Script-kzones.layoutsJson = builtins.readFile ./kzones-layouts.json;
    Plugins.kzonesEnabled = true;
  };
}
