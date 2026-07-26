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

      home = {lib, ...}: {
        programs.kitty.enable = true;

        services.dunst.enable = true;

        wayland.windowManager.hyprland = {
          enable = true;

          # Provided by NixOS module
          package = null;
          portalPackage = null;

          settings = {
            exec = [
              "dunstify -t 1000 Hyprland Configured!!!"
            ];

            monitor = [",preferred,auto,auto"];

            "$mod" = "SUPER";
            bind = [
              "$mod, Return, exec, kitty"
              "$mod, F, exec, firefox"
              "$mod, C, killactive"
              "$mod, V, togglefloating"
            ];
            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];

            windowrule = [
              {
                name = "float-default";
                "match:class" = ".*";
                float = true;
              }
            ];
          };
        };
      };
    };
}
