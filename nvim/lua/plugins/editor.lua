return {
  -- Github theme --
  {
    "projekt0n/github-nvim-theme",
    dependencies = { "xiyaowong/transparent.nvim" },
    config = function()
      require("github-theme").setup({
        options = {
          darken = { floats = true },
          transparent = vim.g.transparent_enabled,
        },
      })

      require("transparent").setup({
        extra_groups = { "NormalFloat", "NvimTreeNormal" },
        exclude_groups = { "CursorLine", "CursorLineNr" },
      })

      vim.cmd([[colorscheme github_dark]])
    end,
  },

  -- Telescope --
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
        { "<leader>fb", builtin.buffers,                      desc = "Buffers" },
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

      telescope.load_extension("noice")
      telescope.load_extension("file_browser")
    end,
  },

  -- Nvim Tree --
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
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
    end,
  },

  -- Which Key --
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
          title = false,
          zindex = 1000,
          ---@type "none" | "single" | "double" | "rounded"
          border = "rounded",
          padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        },
        layout = {
          width = { min = 20 }, -- min and max width of the columns
          spacing = 4,     -- spacing between columns
          align = "center", -- align columns left, center or right
        },

        plugins = { marks = false, registers = false, spelling = false },
      })

      wk.add({
        { "<leader>f", group = "Telescope" },
        { "<leader>l", group = "LSP", icon = { icon = " ", color = "green" } },
        { "<leader>o", group = "Options", icon = { icon = " ", color = "blue" } },
        { "<leader>c", group = "Copilot", icon = { icon = " ", color = "orange" } },
      })
    end,
  },

  -- Lightspeed --
  {
    "ggandor/lightspeed.nvim",
    event = "VeryLazy",
    config = function()
      require("lightspeed").setup({})
    end,
  },

  -- Status Line --
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

  -- Indent Blank Line --
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- Dashboard --
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

  -- Noice --
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
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
          bottom_search = true,    -- use a classic bottom cmdline for search
          command_palette = true,  -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true,       -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,   -- add a border to hover docs and signature help
        },
      })
    end,
  },

  -- Tmux --
  {
    "aserowy/tmux.nvim",
    lazy = false,
    keys = {
      { "<C-Up>",    "<cmd>lua require('tmux').resize_top()<cr>",    desc = "Increase Window Height" },
      { "<C-Left>",  "<cmd>lua require('tmux').resize_left()<cr>",   desc = "Decrease Window Width" },
      { "<C-Right>", "<cmd>lua require('tmux').resize_right()<cr>",  desc = "Increase Window Width" },
      { "<C-Down>",  "<cmd>lua require('tmux').resize_bottom()<cr>", desc = "Decrease Window Height" },
    },
    config = function()
      require("tmux").setup({
        resize = { enable_default_keybindings = false },
      })
    end,
  },
}
