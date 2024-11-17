return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({
        transparent = vim.g.transparent_enabled,
      })
      vim.cmd("colorscheme github_dark")
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = nil })
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        exclude_groups = { "CursorLine" },
      })

      require("transparent").clear_prefix("NvimTree")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = function()
      local builtin = require("telescope.builtin")
      local extensions = require("telescope").extensions

      return {
        { "<leader>fg", builtin.live_grep,                    desc = "Live Grep" },
        { "<leader>ff", builtin.find_files,                   desc = "Find Files" },
        { "<leader>fe", extensions.file_browser.file_browser, desc = "File Browser" },
      }
    end,
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
        pickers = { find_files = { theme = "dropdown" } },
        extensions = { file_browser = { theme = "dropdown" } },
      })

      telescope.load_extension("file_browser")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true

      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 32 },
        renderer = { group_empty = true },
        filters = {
          enable = true,
          dotfiles = false,
          git_ignored = true,
          custom = { ".git" },
          exclude = { ".env", ".env*.local" },
        },
      })

      local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
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
          lualine_b = {
            { "filetype", icon_only = true,   separator = "", padding = { left = 1, right = 0 } },
            { "filename", file_status = true, path = 1 },
            { "branch" },
            { "diff" },
          },
          lualine_c = { "diagnostics" },
          lualine_x = { "encoding", "fileformat", "rest" },
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")

      wk.setup({
        ---@type false | "classic" | "modern" | "helix"
        preset = "modern",

        triggers = { "<leader>", mode = { "n" } },

        win = {
          row = -1,
          title = false,
          zindex = 1000,
          ---@type "none" | "single" | "double" | "rounded"
          border = "rounded",
          padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        },
        layout = {
          width = { min = 20 }, -- min and max width of the columns
          spacing = 4,          -- spacing between columns
          align = "center",     -- align columns left, center or right
        },

        plugins = { marks = false, registers = false, spelling = false },
      })

      wk.add({
        { "<leader>a", group = "Actions", icon = { icon = " ", color = "yellow" } },
        { "<leader>b", group = "Buffers" },
        { "<leader>f", group = "Telescope" },
        { "<leader>g", group = "Git" },
        { "<leader>gc", group = "Copilot" },
        { "<leader>l", group = "LSP", icon = { icon = " ", color = "green" } },
        { "<leader>o", group = "Options", icon = { icon = " ", color = "blue" } },
      })
    end,
  },

  {
    "aserowy/tmux.nvim",
    config = function()
      require("tmux").setup({
        resize = { enable_default_keybindings = false }
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 500,
          ignore_whitespace = true,
        }
      })
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    config = function()
      require("snacks").setup({
        statuscolumn = {
          Config = {
            folds = {
              open = true,   -- show open fold icons
              git_hl = true, -- use Git Signs hl for fold icons
            },
            git = {
              -- patterns to match Git signs
              patterns = { "GitSign" },
            },
          },
        },
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,                                     -- #RGB hex codes
          RRGGBB = true,                                  -- #RRGGBB hex codes
          names = true,                                   -- "Name" codes like Blue or blue
          RRGGBBAA = true,                                -- #RRGGBBAA hex codes
          AARRGGBB = true,                                -- 0xAARRGGBB hex codes
          rgb_fn = true,                                  -- CSS rgb() and rgba() functions
          hsl_fn = true,                                  -- CSS hsl() and hsla() functions
          css = true,                                     -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,                                  -- Enable all CSS *functions*: rgb_fn, hsl_fn
          --- @type string | "foreground" | "background" | "virtualtext"
          mode = "background",                            -- Set the display mode.
          --- @type boolean | "normal" | "lsp" | "both"
          tailwind = "lsp",                               -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = true,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      })
    end,
  },
  {
    "goolord/alpha-nvim",
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      local startify = require("alpha.themes.startify")
      startify.file_icons.provider = "devicons"

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
        dashboard.button("g", "󰈬  Live grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "⏻  Quit", "<cmd>wqa<CR>"),
      }
      dashboard.section.buttons.opts = {
        spacing = 0,
        position = "center",
      }

      -- Footer --
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

        return {
          [[                                              ]],
          [[                                              ]],
          [[                  I believe this world is flat]],
          [[                      Because loli is my world]],
          [[                                              ]],
          [[                                              ]],
          "   ⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms ⚡",
        }
      end

      -- Configuration --
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.opts.opts.noautocmd = true

      -- Set up
      require("alpha").setup(dashboard.opts)
    end,
  },
}
