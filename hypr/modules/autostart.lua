-------------------
---- AUTOSTART ----
-------------------
-- @see https://wiki.hypr.land/configuring/core/autostart

hl.on("hyprland.start", function()
  -- Clipboard managers
  hl.exec_cmd("wl-paste --type text --watch cliphist store")

  -- Input method
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("fcitx5 -d")

  -- Compositors
  hl.exec_cmd("noctalia")
  -- hl.exec_cmd("hypridle -c " .. os.getenv("HOME") .. "/.config/hypr/hypridle.conf")
  -- hl.exec_cmd("hyprpaper")
end)
