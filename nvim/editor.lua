return {
	{
		"projekt0n/github-nvim-theme",
		config = function()
			require("github-theme").setup({
				options = {
					darken = { floats = true },
					transparent = vim.g.transparent_enabled,
				},
			})

			vim.cmd([[colorscheme github_dark]])
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{ "<leader>f", "<nop>", desc = "Telescope" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{ "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
		},

		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			})

			telescope.load_extension("file_browser")
		end,
	},
	{
		"aserowy/tmux.nvim",
		lazy = false,
		keys = {
			{ "<C-Up>", "<cmd>lua require('tmux').resize_top()<cr>", desc = "Increase Window Height" },
			{ "<C-Left>", "<cmd>lua require('tmux').resize_left()<cr>", desc = "Decrease Window Width" },
			{ "<C-Right>", "<cmd>lua require('tmux').resize_right()<cr>", desc = "Increase Window Width" },
			{ "<C-Down>", "<cmd>lua require('tmux').resize_bottom()<cr>", desc = "Decrease Window Height" },
		},
		config = function()
			require("tmux").setup({
				resize = { enable_default_keybindings = false },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")

			wk.setup({
				---@type false | "classic" | "modern" | "helix"
				preset = "modern",

				triggers = { "<leader>", mode = { "n" } },

				win = {
					row = -1,
					border = "none",
					padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
					title = true,
					title_pos = "center",
					zindex = 1000,
					bo = {},
					wo = {
						winblend = 1, -- value between 0-100 0 for fully opaque and 100 for fully transparent
					},
				},
				layout = {
					width = { min = 20 }, -- min and max width of the columns
					spacing = 4, -- spacing between columns
					align = "center", -- align columns left, center or right
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },
		},
		config = function()
			local status_ok, nvim_tree = pcall(require, "nvim-tree")
			if not status_ok then
				return
			end

			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true

			nvim_tree.setup({
				sort = { sorter = "case_sensitive" },
				view = { width = 24 },
				renderer = { group_empty = true },
				filters = {
					enable = true,
					dotfiles = false,
					git_ignored = true,
					custom = { ".git" },
					exclude = { ".env", ".env*.local" },
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
			{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev tab" },
		},
		config = function()
			require("bufferline").setup({
				options = {
					max_name_length = 15,
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							highlight = "Directory",
							text_align = "center",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					disabled_filetypes = { "alpha", "NvimTree" },
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", file_status = true, separator = "", path = 1 },
						{ "diff" },
						{ "diagnostics" },
					},
					lualine_x = { "encoding", "fileformat" },
					lualine_y = {
						{ "progress", padding = { left = 1, right = 0 }, separator = "" },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup()
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
	{
		"goolord/alpha-nvim",
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			-- Header --
			dashboard.section.header.val = {
				[[                                              ]],
				[[                                              ]],
				[[█████████╗██╗███████╗██████╗███████╗███╗   ██╗]],
				[[ ╚══██╔══╝██║██╔════╝██╔═══╝██╔════╝████╗  ██║]],
				[[    ██║   ██║█████╗  ██████╗█████╗  ██╔██╗ ██║]],
				[[    ██║   ██║██╔══╝  ╚═══██║██╔══╝  ██║╚██╗██║]],
				[[    ██║   ██║███████╗██████║███████╗██║ ╚████║]],
				[[    ╚═╝   ╚═╝╚══════╝╚═════╝╚══════╝╚═╝  ╚═══╝]],
				[[                                              ]],
				[[                    @tiesen243                ]],
			}

			-- Buttons --
			dashboard.section.buttons.val = {
				dashboard.button("n", "  New file", "<cmd>enew<CR>"),
				dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
				dashboard.button("g", "󰈬  Find word", "<cmd>Telescope live_grep<CR>"),
				dashboard.button("r", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
				dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
				dashboard.button("q", "⏻  Quit", "<cmd>wqa<CR>"),
			}
			dashboard.section.buttons.opts = {
				spacing = 0,
				position = "center",
			}

			-- Footer --
			dashboard.section.footer.val = {
				[[                                              ]],
				[[                                              ]],
				[[                  I believe this world is flat]],
				[[                          Cuz loli is my world]],
				[[                                              ]],
				[[                                   Yukikaze <4]],
			}

			-- Configuration --
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"
			dashboard.opts.opts.noautocmd = true

			-- Set up
			require("alpha").setup(dashboard.opts)
		end,
	},
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
		end,
	},
}
