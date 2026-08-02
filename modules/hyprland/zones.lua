local zones = {
  {k = "KP_Down"; x = 25; y = 40; w = 50; h = 60;}, -- Bottom Middle
  {k = "KP_Up"; x = 25; y = 0; w = 50; h = 40;}, -- Top Middle
  {k = "KP_Next"; x = 75; y = 40; w = 25; h = 60;}, -- Bottom Right
  {k = "KP_End"; x = 0; y = 40; w = 25; h = 60;}, -- Bottom Left
  {k = "KP_Prior"; x = 75; y = 0; w = 25; h = 40;}, -- Top Right
  {k = "KP_Home"; x = 0; y = 0; w = 25; h = 40;}, -- Top Left
}

---@param window HL.Window
---@return integer?
local function get_zoneindex(window)
  local tags = window.tags or {} ---@cast tags string[]

  for  _, tag in ipairs(tags) do
    for zoneindex, _ in ipairs(zones) do
      if tag == ("zone:" .. zoneindex) then
        return zoneindex
      end
    end
  end
end

---@param new_zoneindex integer
---@param window HL.Window?
local function set_zoneindex(new_zoneindex, window)
  for zoneindex, _ in ipairs(zones) do
      hl.dispatch(hl.dsp.window.tag({ tag = "-zone:" .. zoneindex, window = window }))
  end

  hl.dispatch(hl.dsp.window.tag({ tag = "+zone:" .. new_zoneindex, window = window }))
end

---@param ctx HL.LayoutContext
---@return table<integer, HL.LayoutTarget[]>, table<HL.LayoutTarget, integer>
local function get_zone_target_maps(ctx)
  local targets_by_zoneindex = {}
  local zoneindex_by_target = {}

  for zoneindex, _ in ipairs(zones) do
    targets_by_zoneindex[zoneindex] = {}
  end

  for _, target in ipairs(ctx.targets) do
    local zoneindex = target.window and get_zoneindex(target.window)

    if zoneindex ~= nil then
      table.insert(targets_by_zoneindex[zoneindex], target)
      zoneindex_by_target[target] = zoneindex
    end
  end

  return targets_by_zoneindex, zoneindex_by_target
end

hl.layout.register("zones", {
  recalculate = function(ctx)
    local targets_by_zoneindex, zoneindex_by_target = get_zone_target_maps(ctx)

    local min_zone_target_count = 999
    for zoneindex, _ in ipairs(zones) do
      min_zone_target_count = math.min(min_zone_target_count, #targets_by_zoneindex[zoneindex])
    end

    -- Auto assign least cramped zone
    for _, target in ipairs(ctx.targets) do
      if target.window ~= nil and zoneindex_by_target[target] == nil then
        for zoneindex, targets in pairs(targets_by_zoneindex) do
            if #targets == min_zone_target_count then
            set_zoneindex(zoneindex, target.window)
            hl.dispatch(hl.dsp.layout("recalculate"))
            return
          end
        end
      end
    end

    for zoneindex, targets in pairs(targets_by_zoneindex) do
      local zone = zones[zoneindex]
        local zone_area = {
          x = ctx.area.x + ctx.area.w * zone.x / 100,
          y = ctx.area.y + ctx.area.h * zone.y / 100,
          w = ctx.area.w * zone.w / 100,
          h = ctx.area.h * zone.h / 100,
        }

      for i, target in ipairs(targets) do
        target:place({
          x = zone_area.x + zone_area.w * (i - 1) / #targets,
          y = zone_area.y,
          w = zone_area.w / #targets,
          h = zone_area.h
        })
      end
    end
  end,

  layout_msg = function(ctx, msg)
    if msg == "recalculate" then
      return true
    end

    do
      local move, new_zoneindex_str, swap_str = msg:match("(move) (%d+) (%a+)")
      local window = hl.get_active_window()
      if move ~= nil and window ~= nil then
        local new_zoneindex = tonumber(new_zoneindex_str) ---@cast new_zoneindex integer

        local current_zoneindex = get_zoneindex(window)
        if swap_str == "swap" and current_zoneindex ~= nil then

          local targets_by_zoneindex, _ = get_zone_target_maps(ctx)

          for _, target in ipairs(targets_by_zoneindex[new_zoneindex]) do
            set_zoneindex(current_zoneindex, target.window)
          end
        end

        hl.dispatch(hl.dsp.window.float({ action = "off", window = window }))
        set_zoneindex(new_zoneindex, window)

        return true
      end
    end

    do
      local focus, zoneindex_str = msg:match("(focus) (%d+)")
        local zoneindex = tonumber(zoneindex_str) ---@cast zoneindex integer
        if focus ~= nil then

        local targets_by_zoneindex, _ = get_zone_target_maps(ctx)

        local target = targets_by_zoneindex[zoneindex][1]

        if (target and target.window) ~= nil then
          hl.dispatch(hl.dsp.focus({ window = target.window }))
        end
      end
    end
  end
})

for i, zone in ipairs(zones) do
  hl.bind(zone.k, hl.dsp.layout("focus " .. i))
  hl.bind("SUPER + " .. zone.k, hl.dsp.layout("move " .. i .. " swap"))
  hl.bind("SUPER + ALT + " .. zone.k, hl.dsp.layout("move " .. i .. " keep"))
end

hl.config({
  general = {
    layout = "lua:zones",
    gaps_in = 10,
    gaps_out = 20,
  },
})


