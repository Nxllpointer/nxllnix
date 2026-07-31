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

        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      '';
  };
}
