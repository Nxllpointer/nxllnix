{
  configuration = {
    globalconfig,
    lib,
    ...
  }: {
    home.wayland.windowManager.hyprland.extraConfig =
      lib.mkIf globalconfig.gui.enable
      # lua
      ''
        local zones = {
          -- Top row
          {k = "KP_Home"; x = 0; y = 0; w = 25; h = 40;},
          {k = "KP_Up"; x = 25; y = 0; w = 50; h = 40;},
          {k = "KP_Prior"; x = 75; y = 0; w = 25; h = 40;},
          -- Full height
          {k = "KP_Left"; x = 0; y = 0; w = 25; h = 100;},
          {k = "KP_Begin"; x = 25; y = 0; w = 50; h = 100;},
          {k = "KP_Right"; x = 75; y = 0; w = 25; h = 100;},
          -- Bottom row
          {k = "KP_End"; x = 0; y = 40; w = 25; h = 60;},
          {k = "KP_Down"; x = 25; y = 40; w = 50; h = 60;},
          {k = "KP_Next"; x = 75; y = 40; w = 25; h = 60;},
        }

        local gap = 15

        local function move_to(zone)
          local window = hl.get_active_window()
          local monitor = window.monitor
          local reserved = monitor.reserved

          local x = monitor.x + reserved.left + gap
          local y = monitor.y + reserved.top + gap
          local width = monitor.width - reserved.left - reserved.right - 2*gap
          local height = monitor.height - reserved.top - reserved.bottom - 2*gap

          hl.dispatch(hl.dsp.window.resize({
            window = window,
            x = width * zone.w / 100 - 2*gap,
            y = height * zone.h / 100 - 2*gap,
          }))
          hl.dispatch(hl.dsp.window.move({
            window = window,
            x = x + width * zone.x / 100 + gap,
            y = y + height * zone.y / 100 + gap,
          }))

          hl.notification.create({text=tostring(x + width * zone.x / 100), duration=1000 })
        end

        for _, zone in ipairs(zones) do
          hl.bind(zone.k, function()
              move_to(zone)
          end)
        end

      '';
  };
}
