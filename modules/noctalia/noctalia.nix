{
  inputs,
  lib,
  ...
}: {
  configuration = {globalconfig, ...}:
    lib.mkIf globalconfig.gui.enable {
      home = {pkgs, ...}: {
        imports = [inputs.noctalia.homeModules.default];

        programs.noctalia = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          systemd.enable = true;

          settings = {
            bar.default = {
              start = ["launcher" "media" "audio_visualizer" "weather" "nix-monitor"];
              center = ["taskbar"];
              end = [
                "tray"
                "notifications"
                "clipboard"
                "volume"
                "input_volume"
                "network"
                "bluetooth"
                "brightness"
                "battery"
                "session"
                "clock"
              ];
              position = "bottom";
              radius = 80;
              scale = 1.2;
              thickness = 48;
              widget_spacing = 15;
            };

            widget.taskbar = {
              capsule_radius = 7;
              group_by_workspace = true;
              scale = 1.5;
              show_workspace_label = false;
            };

            widget.media = {
              album_art_only = true;
              max_length = 40;
              min_length = 0;
            };

            widget.audio_visualizer.show_when_idle = true;

            widget.nix-monitor.type = "avivbintangaringga/nix-monitor:nix-monitor";

            wallpaper.default.path = ./wallpaper.png;
            wallpaper.last.path = ./wallpaper.png;

            location.auto_locate = true;

            shell.mpris.blacklist = ["firefox"];

            shell.polkit_agent = true;

            osd.kinds.media = false;


            plugins.enabled = ["avivbintangaringga/nix-monitor"];
            plugin_settings."avivbintangaringga/nix-monitor" = {
              update_command = "nxllnix-update && nxllnix-rebuild";
              clean_command = "nix store gc -vv";
              optimize_command = "nix store optimise -vv";
              panel_card_opacity = 99;
            };
          };
        };

        xdg.stateFile."noctalia/.setup-complete" = {
          force = true;
          text = "";
        };
      };
    };
}
