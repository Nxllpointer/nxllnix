---@diagnostic disable-next-line: unused-local, unused-function
local function notify(msg)
      hl.notification.create({text=msg, timeout=1000})
end

hl.exec_cmd("noctalia msg notification-show 'Hyprland Configured!'")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "altgr-intl",
    follow_mouse = 2
  },
  cursor = {
    no_warps = true
  }
})
