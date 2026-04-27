{
  flake.modules.homeManager.gui = {pkgs, ...}: {
    programs = {
      firefox = {
        enable = true;

        profiles = {
          default = {
            id = 0;
            settings = {};
            search = {
              default = "ddg";
              force = true;
            };
          };
        };
      };

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
