{
  configuration = {
    globalconfig,
    lib,
    ...
  }:
    lib.mkIf globalconfig.gui.enable {
      home = {pkgs, ...}: {
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

        persisted.directories = lib.mkIf globalconfig.impermanence.enable [
          ".config/mozilla/firefox"
          ".config/chromium"
        ];
      };
    };
}
