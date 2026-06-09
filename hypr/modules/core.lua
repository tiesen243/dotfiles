-----------------------
----   LAYOUTS     ----
-----------------------

hl.config({
  general = {
    layout = "scrolling",
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
  dwindle = {
    preserve_split = true,
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
  master = {
    new_status = "master",
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
  scrolling = {
    explicit_column_widths = "0.33333, 0.5, 0.66667",
  },
})

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
  direction = hl.get_config("general.layout") == "scrolling" and "vertical" or "horizontal",
  action = "workspace",
})

hl.gesture({
  fingers = 3,
  direction = hl.get_config("general.layout") == "scrolling" and "left" or "up",
  action = function()
    local layout = hl.get_config("general.layout")

    if layout == "scrolling" then
      hl.dispatch(hl.dsp.layout("move +col"))
    elseif layout == "monocle" then
      hl.dispatch(hl.dsp.layout("cyclenext"))
    end
  end,
})

hl.gesture({
  fingers = 3,
  direction = hl.get_config("general.layout") == "scrolling" and "right" or "down",
  action = function()
    local layout = hl.get_config("general.layout")

    if layout == "scrolling" then
      hl.dispatch(hl.dsp.layout("move -col"))
    elseif layout == "monocle" then
      hl.dispatch(hl.dsp.layout("cycleprev"))
    end
  end,
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
