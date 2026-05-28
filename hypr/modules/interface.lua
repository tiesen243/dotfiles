-----------------------
---- LOOK AND FEEL ----
-----------------------

local colors = require("modules.colors")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 4,

    border_size = 1,
    col = {
      active_border = {
        colors = { colors.primary, colors.tertiary },
        angle = 45,
      },
      inactive_border = {
        colors = { colors.on_primary, colors.on_tertiary },
        angle = 45,
      },
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true,
    extend_border_grab_area = 8,
    hover_icon_on_border = true,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = false,

    -- @see https://wiki.hypr.land/Configuring/Variables/#snap
    snap = {
      enabled = false,
      window_gap = 4,
      monitor_gap = 4,
      border_overlap = false,
      respect_gaps = true,
    },
  },

  decoration = {
    rounding = 8,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,

    blur = {
      enabled = false,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },

    shadow = {
      enabled = false,
      range = 8,
      render_power = 2,
      color = colors.shadow,
    },
  },

  animations = {
    enabled = true,
  },
})

hl.curve("fluent", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("expo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 3, spring = "easy" })
hl.animation({ leaf = "layers", enabled = false })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "fluent", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, bezier = "fluent" })

hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "fluent" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "expo", style = "slidefadevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "fluent", style = "fade" })
