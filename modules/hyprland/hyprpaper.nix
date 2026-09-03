{
  configuration = {
    globalconfig,
    lib,
    ...
  }:
    lib.mkIf globalconfig.gui.enable {
  home = {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [{
          monitor = "";
          fit_mode = "cover";
          path = toString ./wallpaper.png;
        }];
      };
    };
  };
  };
}
