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

      home = {lib, pkgs, ...}: {
        programs.kitty.enable = true;

        wayland.windowManager.hyprland = {
          enable = true;

          # Provided by NixOS module
          package = null;
          portalPackage = null;
        };

        home.pointerCursor = {
          enable = true;
          name = "BreezeX-RosePine-Linux";
          size = 64;
          package = pkgs.rose-pine-cursor;
          hyprcursor.enable = true;
          hyprcursor.size = 64;
          gtk.enable = true;
          x11.enable = true;
        };

        wayland.windowManager.hyprland.extraConfig =
          # lua
          ''
            ${builtins.readFile ./hyprland.lua}
            ${builtins.readFile ./zones.lua}
            ${builtins.readFile ./workspaces.lua}
            ${builtins.readFile ./binds.lua}
            ${builtins.readFile ./cursor.lua}

            require("./testing")
          '';

        home.activation.createHyprlandTesting = lib.hm.dag.entryAfter ["linkGeneration"] ''
          touch $HOME/.config/hypr/testing.lua
        '';
      };
    };
}
