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
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local scripts = os.getenv("HOME") .. "/dotfiles/scripts"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- Quickshell
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("quickshell ipc call appLauncher toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("quickshell ipc call clipboardManager toggle"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("quickshell ipc call startMenu toggle"))

-- Layout
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + O", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.layout("togglesplit")) -- dwindle only

-- Focus with mainMod + h/j/k/l
-- Move active windows with mainMod + SHIFT + h/j/k/l
-- Resize windows with mainMod + ALT + h/j/k/l
local directions = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(directions) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
	-- hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.resize({ direction = direction }))
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll window with mainMod + [ and ]
-- Swap window with mainMod + SHIFT + [ and ]
-- for _, key in ipairs({ "[", "]" }) do
-- end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

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

-- Screenshot with NONE/SHIFT + PrintScreen key or mainMod + NONE/SHIFT + S
hl.bind("PRINT", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode region"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode fullscreen"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode region"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh --mode fullscreen"))
