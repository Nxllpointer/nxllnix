{
  configuration = {
    globalconfig,
    lib,
    ...
  }:
    lib.mkIf globalconfig.gui.enable {
      nixos = {
        programs.hyprland.enable = true;
        services.displayManager.ly.enable = true;
      };

      home = {
        programs.kitty.enable = true;

        services.dunst.enable = true;

        wayland.windowManager.hyprland = {
          enable = true;

          # Provided by NixOS module
          package = null;
          portalPackage = null;
        };
      };

      home.wayland.windowManager.hyprland.extraConfig =
        # lua
        ''
          require("./testing")

          hl.exec_cmd("noctalia msg notification-show 'Hyprland Configured!'")

          hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

          hl.config({
            input = {
              kb_layout = "us",
              kb_variant = "altgr-intl",
              follow_mouse = 2
            },
            cursor = {
              no_warps = true
            }
          })

          hl.window_rule({
            match = { class = ".*" },
            float = true,
          })
        '';
    };
}
