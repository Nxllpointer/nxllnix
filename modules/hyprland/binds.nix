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
        hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
        hl.bind("SUPER + F", hl.dsp.exec_cmd("firefox"))
        hl.bind("SUPER + C", hl.dsp.window.close())
        hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))

        hl.bind("SUPER + SUPER_L", hl.dsp.exec_raw("noctalia msg panel-toggle launcher"))

        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

        for _, direction in ipairs({ "left", "right", "up", "down" }) do
          hl.bind("SUPER + " .. direction, hl.dsp.focus({ direction = direction }))
        end
      '';
  };
}
