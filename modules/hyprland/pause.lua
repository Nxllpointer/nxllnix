local unmap_all = hl.window_rule({
  name = "unmap-all",
  match = { class = ".*" },
  enabled = false,
  opacity = 0,
  no_anim = true
})

local unmap_inactive = hl.window_rule({
  name = "unmap-inactive",
  match = { focus = false },
  enabled = false,
  opacity = 0,
  no_anim = true
})

hl.bind("SUPER + d", function()
  hl.exec_cmd("playerctl -a pause")
  unmap_inactive:set_enabled(false)
  unmap_all:set_enabled(not unmap_all:is_enabled())
end)

hl.bind("SUPER + SHIFT + d", function()
  hl.exec_cmd("playerctl -a pause")
  unmap_all:set_enabled(false)
  unmap_inactive:set_enabled(not unmap_inactive:is_enabled())
end)
