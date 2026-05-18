-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
  -- Hyprland components
  hl.exec_cmd("hypridle")
  -- hl.exec_cmd("hyprpaper")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- Clipboard managers
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  -- Input method
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("fcitx5 -d")

  -- Theme
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme '" .. os.getenv("GTK_THEME") .. "'")

  -- User applications
  hl.exec_cmd("quickshell")
end)
