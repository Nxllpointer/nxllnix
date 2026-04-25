{
  flake.modules.homeManager.gui = {pkgs, ...}: {
    programs = {
      firefox.enable = true;
      chromium.enable = true;
    };
  };
}
