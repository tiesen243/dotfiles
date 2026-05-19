---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local browser = "zen-browser"
local fileManager = "thunar"
local terminal = "kitty"

---------------------
---- KEYBINDINGS ----
---------------------

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local priMod = "SUPER"
local secMod = "SUPER + SHIFT"
local scripts = os.getenv("HOME") .. "/dotfiles/scripts"

hl.bind(priMod .. " + Q", hl.dsp.window.close())
hl.bind(priMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(priMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(priMod .. " + B", hl.dsp.exec_cmd(browser))

-- Quickshell
hl.bind(priMod .. " + SPACE", hl.dsp.exec_cmd("quickshell ipc call appLauncher toggle"))
hl.bind(priMod .. " + V", hl.dsp.exec_cmd("quickshell ipc call clipboardManager toggle"))
hl.bind(priMod .. " + A", hl.dsp.exec_cmd("quickshell ipc call startMenu toggle"))

-- Layout
hl.bind(priMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(secMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(priMod .. " + O", hl.dsp.window.pseudo())
hl.bind(secMod .. " + O", hl.dsp.layout("togglesplit"))

-- Focus with priMod + h/j/k/l
-- Move active windows with secMod + h/j/k/l
-- Resize windows with priMod + ALT + h/j/k/l
local directions = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(directions) do
  hl.bind(priMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
  hl.bind(secMod .. " + " .. key, hl.dsp.window.move({ direction = direction }))
  hl.bind(
    priMod .. " + ALT + " .. key,
    hl.dsp.window.resize({
      x = key == "h" and -10 or key == "l" and 10 or 0,
      y = key == "j" and 10 or key == "k" and -10 or 0,
      relative = true,
    }),
    { repeating = true }
  )
end

-- Switch workspaces with priMod + [0-9]
-- Move active window to a workspace with secMod + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(priMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(secMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(priMod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(secMod .. " + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with priMod + scroll
hl.bind(priMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(priMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with priMod + LMB/RMB and dragging
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

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshot with PrintScreen key or priMod/secMod + S
hl.bind("PRINT", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode region"))
hl.bind(priMod .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode region"))
hl.bind(secMod .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode fullscreen"))
