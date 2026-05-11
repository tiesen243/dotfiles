--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(false)

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

-- hl.window_rule({
-- 	name = "no-gaps-wtv1",
-- 	match = { float = false, workspace = "w[tv1]" },
-- 	border_size = 0,
-- 	rounding = 0,
-- })

-- hl.window_rule({
-- 	name = "no-gaps-f1",
-- 	match = { float = false, workspace = "f[1]" },
-- 	border_size = 0,
-- 	rounding = 0,
-- })

hl.window_rule({
	name = "floating-file-utility",
	match = { class = "^xdg-desktop-portal-gtk", title = "^File$" },
	float = true,
	center = true,
	size = { 640, 480 },
})

hl.window_rule({
	name = "floating-rename",
	match = { class = "^thunar$", title = "^Rename$" },
	float = true,
	center = true,
	size = { 400, 150 },
})

hl.window_rule({
	name = "floating-picture-in-picture",
	match = { title = "^Picture-in-Picture$" },
	float = true,
	size = { 540, 300 },
	move = { 1920 - 540 - 16, 1080 - 300 - 16 },
})

hl.window_rule({
	name = "no-opacity-for-browser",
	match = { class = "^zen$" },
	opacity = "1.0 override",
})

-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)
