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

        wayland.windowManager.hyprland = {
          enable = true;

          # Provided by NixOS module
          package = null;
          portalPackage = null;
        };

        wayland.windowManager.hyprland.extraConfig =
          # lua
          ''
            ${builtins.readFile ./hyprland.lua}
            ${builtins.readFile ./zones.lua}
            ${builtins.readFile ./workspaces.lua}
            ${builtins.readFile ./binds.lua}

            require("./testing")
          '';

        home.activation.createHyprlandTesting = lib.hm.dag.entryAfter ["linkGeneration"] ''
          touch $HOME/.config/hypr/testing.lua
        '';
      };
    };
}
