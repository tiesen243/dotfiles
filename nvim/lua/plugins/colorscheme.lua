return {
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({
				options = {
					transparent = vim.g.transparent_enabled,
					dim_inactive = true,
					darken = { floats = true },
					styles = {
						comments = "NONE",
						conditionals = "NONE",
						constants = "bold",
						functions = "bold",
						keywords = "NONE",
						numbers = "NONE",
						operators = "NONE",
						strings = "NONE",
						types = "italic",
						variables = "NONE",
					},
				},
			})

			vim.cmd([[colorscheme github_dark_default]])
		end,
	},
	{
		"xiyaowong/transparent.nvim",
		config = function()
			local transparent = require("transparent")

			transparent.setup({
				extra_groups = { "NormalFloat", "NvimTreeNormal" },
				exclude_groups = { "CursorLine" },
			})

			transparent.clear_prefix("NeoTree")
			transparent.clear_prefix("BufferLine")

			vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "ExtraGroup" })
			vim.g.transparent_groups = vim.list_extend(
				vim.g.transparent_groups or {},
				vim.tbl_map(function(v)
					return v.hl_group
				end, vim.tbl_values(require("bufferline.config").highlights))
			)
		end,
	},
}
