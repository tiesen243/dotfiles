---------------------
---- KEYBINDINGS ----
---------------------

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local priMod = "SUPER"
local secMod = "SUPER + SHIFT"
local terMod = "SUPER + CTRL"

-- Core Apps & Actions
hl.bind(priMod .. " + Q", hl.dsp.window.close())

hl.bind(priMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(priMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(priMod .. " + B", hl.dsp.exec_cmd("zen-browser"))

-- Noctalia
hl.bind(priMod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(priMod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(priMod .. " + A", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
hl.bind(priMod .. " + X", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(terMod .. " + N", hl.dsp.exec_cmd("pkill -9 noctalia; noctalia"))

local directions = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(directions) do
  -- Focus window
  hl.bind(priMod .. " + " .. key, function()
    local layout = hl.get_config("general.layout")

    if layout == "scrolling" and (key == "h" or key == "l") then
      hl.dispatch(hl.dsp.layout("move " .. (key == "h" and "-col" or "+col")))
    elseif layout == "monocle" and (key == "h" or key == "l") then
      hl.dispatch(hl.dsp.layout("cycle" .. (key == "h" and "prev" or "next")))
    else
      hl.dispatch(hl.dsp.focus({ direction = direction }))
    end
  end)

  -- Move window
  hl.bind(secMod .. " + " .. key, function()
    local layout = hl.get_config("general.layout")

    if layout == "scrolling" and (key == "h" or key == "l") then
      hl.dispatch(hl.dsp.layout("swapcol " .. (key == "h" and "l" or "r")))
    else
      hl.dispatch(hl.dsp.window.move({ direction = direction }))
    end
  end)

  -- Resize window
  hl.bind(
    terMod .. " + " .. key,
    hl.dsp.window.resize({
      x = key == "h" and -10 or key == "l" and 10 or 0,
      y = key == "j" and 10 or key == "k" and -10 or 0,
      relative = true,
    }),
    { repeating = true }
  )
end

-- Workspaces
for key = 1, 9 do
  hl.bind(priMod .. " + " .. key, hl.dsp.focus({ workspace = key }))
  hl.bind(secMod .. " + " .. key, hl.dsp.window.move({ workspace = key }))
end

-- Layout controls
hl.bind(priMod .. " + comma", function()
  local layout = hl.get_config("general.layout")

  if layout == "scrolling" then
    hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
  end
end)
hl.bind(priMod .. " + period", function()
  local layout = hl.get_config("general.layout")

  if layout == "scrolling" then
    hl.dispatch(hl.dsp.layout("consume_or_expel next"))
  end
end)
hl.bind(priMod .. " + R", function()
  local layout = hl.get_config("general.layout")

  if layout == "scrolling" then
    hl.dispatch(hl.dsp.layout("colresize +conf"))
  end
end)
hl.bind(secMod .. " + R", function()
  local layout = hl.get_config("general.layout")

  if layout == "scrolling" then
    hl.dispatch(hl.dsp.layout("colresize -conf"))
  end
end)

-- Window states
hl.bind(priMod .. " + C", hl.dsp.window.center())
hl.bind(priMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(secMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(terMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Mouse bindings
hl.bind(priMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(priMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(priMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(priMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -n2 set 5%-"), { locked = true, repeating = true })

-- Playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind(priMod .. " + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind(secMod .. " + S", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
