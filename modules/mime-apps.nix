{
  flake.modules.homeManager.gui = {pkgs, ...}: {
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;

      defaultApplicationPackages = with pkgs; [
        firefox
      ];
    };
  };
}
