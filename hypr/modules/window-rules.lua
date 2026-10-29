--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- @see https://wiki.hypr.land/configuring/core/rules

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

hl.window_rule({
  name = "floating-rename",
  match = { class = "^thunar", title = "^(Rename.*)$" },
  float = true,
  center = true,
  size = { 400, 150 },
})

hl.window_rule({
  name = "floating-picture-in-picture",
  match = { title = "^(Picture-in-Picture)$" },
  float = true,
  size = { 640, 360 },
  move = { 1920 - 640 - 4, 1080 - 360 - 4 },
})
