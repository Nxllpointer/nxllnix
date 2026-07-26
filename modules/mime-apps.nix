{
  configuration = {
    globalconfig,
    lib,
    ...
  }:
    lib.mkIf globalconfig.gui.enable {
      home = {pkgs, ...}: {
        xdg.configFile."mimeapps.list".force = true;
        xdg.mimeApps = {
          enable = true;

          defaultApplicationPackages = with pkgs; [
            firefox
          ];
        };
      };
    };
}
