{
  flake.modules.homeManager.gui = {pkgs, ...}: {
    programs = {
      firefox.enable = true;
      chromium.enable = true;
    };
  };

  flake.modules.homeManager.impermanence = {
    persisted.directories = [
      ".config/mozilla/firefox"
      ".config/chromium"
    ];
  };
}
