{
  flake.modules.homeManager.gui = {lib, config, ...}: let
    gap = 20;
    pad = {
      l = gap / 2 + 0;
      r = gap / 2 + 0;
      t = gap / 2 + 0;
      b = gap / 2 + 0;
    };
  in {
    wayland.windowManager.hyprland.settings.bind = lib.flatten (
      map ({
        k,
        x,
        y,
        w,
        h,
      }: [
        # Resize to available area
        ", ${k}, resizeactive, exact 100% 100%"
        ", ${k}, resizeactive, -${toString (pad.l + pad.r)} -${toString (pad.t + pad.b)}"
        # Scale to size
        ", ${k}, resizeactive, -${toString (100 - w)}% -${toString (100 - h)}%"
        # Move to available area max pos
        ", ${k}, moveactive, exact 100% 100%"
        ", ${k}, moveactive, -${toString (pad.l + pad.r)} -${toString (pad.t + pad.b)}"
        # Scale and move to position
        ", ${k}, moveactive, -${toString (100 - x)}% -${toString (100 - y)}%"
        ", ${k}, moveactive, ${toString pad.l} ${toString pad.t}"
        # Apply gap
        ", ${k}, resizeactive, -${toString gap} -${toString gap}"
      ])
      [
        # Top row
        {
          k = "KP_Home";
          x = 0;
          y = 0;
          w = 25;
          h = 40;
        }
        {
          k = "KP_Up";
          x = 25;
          y = 0;
          w = 50;
          h = 40;
        }
        {
          k = "KP_Prior";
          x = 75;
          y = 0;
          w = 25;
          h = 40;
        }
        # Full height
        {
          k = "KP_Left";
          x = 0;
          y = 0;
          w = 25;
          h = 100;
        }
        {
          k = "KP_Begin";
          x = 25;
          y = 0;
          w = 50;
          h = 100;
        }
        {
          k = "KP_Right";
          x = 75;
          y = 0;
          w = 25;
          h = 100;
        }
        # Bottom row
        {
          k = "KP_End";
          x = 0;
          y = 40;
          w = 25;
          h = 60;
        }
        {
          k = "KP_Down";
          x = 25;
          y = 40;
          w = 50;
          h = 60;
        }
        {
          k = "KP_Next";
          x = 75;
          y = 40;
          w = 25;
          h = 60;
        }
      ]
    );
  };
}
