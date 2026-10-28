--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

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
  name = "noctalia",
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
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
