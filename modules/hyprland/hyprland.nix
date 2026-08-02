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
          ${builtins.readFile ./hyprland.lua}
          ${builtins.readFile ./zones.lua}
          ${builtins.readFile ./workspaces.lua}
          ${builtins.readFile ./binds.lua}

          require("./testing")
        '';
    };
}
