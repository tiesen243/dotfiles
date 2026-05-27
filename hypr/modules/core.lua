----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_scale_notification = false,

    vrr = true,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    numlock_by_default = true,
    follow_mouse = 1,
    sensitivity = 0,

    -- @see https://wiki.hypr.land/Configuring/Variables/#touchpad
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      tap_and_drag = true,
    },

    -- @see https://wiki.hypr.land/Configuring/Variables/#touchdevice
    touchdevice = {
      enabled = false,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
