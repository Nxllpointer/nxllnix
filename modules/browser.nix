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

            policies = {
              ExtensionSettings = {
                "uBlock0@raymondhill.net" = {
                  installation_mode = "normal_installed";
                  private_browsing = true;
                };
                "sponsorBlocker@ajay.app".installation_mode = "normal_installed";
                "tubemod@extension.com".installation_mode = "normal_installed";
                "addon@darkreader.org".installation_mode = "normal_installed";
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
