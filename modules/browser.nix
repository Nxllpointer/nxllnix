{
  flake.modules.homeManager.gui = {pkgs, ...}: {
    programs = {
      firefox.enable = true;
      chromium.enable = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplicationPackages = with pkgs; [firefox];
    };
  };
}
