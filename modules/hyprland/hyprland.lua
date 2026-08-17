---@diagnostic disable-next-line: unused-local, unused-function
local function notify(msg)
  hl.notification.create({ text = msg, timeout = 1000 })
end

hl.exec_cmd("noctalia msg notification-show 'Hyprland Configured!'")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({
  general = {
    border_size = 0,
  },
  decoration = {
    shadow = {
      color = {
        colors = {
          "#FF0000",
          "#FFFF00",
          "#00FF00",
          "#00FFFF",
          "#0000FF",
          "#FF00FF",
          "#FF0000",
        },
        angle = 20
      },
      color_inactive = "#000000",
      range = 15,
      render_power = 3,
    }
  },
  input = {
    kb_layout = "us",
    kb_variant = "altgr-intl",
    follow_mouse = 2
  },
  cursor = {
    no_warps = true
  },
  ecosystem = {
    no_donation_nag = true,
    no_update_news = true
  },
  misc = {
    background_color = "#000000",
    disable_hyprland_logo = true,
  }
})
