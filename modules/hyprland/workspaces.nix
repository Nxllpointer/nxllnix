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
        local WORKSPACES = 5
        for i = 1, WORKSPACES do
          hl.workspace_rule({ workspace = tostring(i), persistent = true })
        end

        local function move_to_workspace(workspace)
          hl.config({ animations = { enabled = false } })
          hl.dispatch(hl.dsp.window.move({ workspace = workspace, follow = true }))
          hl.timer(
            function() hl.config({ animations = { enabled = true } }) end,
            { timeout=1, type="oneshot" }
          )
        end

        hl.bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "e-1" }))
        hl.bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "e+1" }))

        hl.bind("CTRL + SUPER + ALT + Left", function() move_to_workspace("e-1") end)
        hl.bind("CTRL + SUPER + ALT + Right", function() move_to_workspace("e+1") end)
      '';
  };
}
