return {
  -- Keymap hint
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = "modern",
      triggers = { { "<leader>", mode = "n" } },
      spec = {
        {
          mode = { "n" },
          { "<leader>b",  group = "Buffers" },
          { "<leader>c",  group = "Code" },
          { "<leader>f",  group = "Finder" },
          { "<leader>g",  group = "Git" },
          { "<leader>q",  group = "Quit" },
          { "<leader>t",  group = "Terminal" },
          { "<leader>gc", group = "Copilot" },
          { "<leader>u",  group = "UI" },
        },
      },
    },
  },

  -- Telescope
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        { "<leader>fg", builtin.live_grep,  desc = "Live Grep" },
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
      }
    end,
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      }
    end,
  },

  -- Snacks: A collection of small QoL plugins for Neovim
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
 ╚████╔╝ ██║   ██║█████╔╝ ██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║
   ██║   ╚██████╔╝██║  ██╗██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
          ]],
        },
      },

      animate = {},
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scroll = {},
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        ignore_whitespace = true,
      },
    },
  },

  -- Basics config
  -- https://github.com/echasnovski/mini.basics
  {
    "echasnovski/mini.basics",
    opts = {
      -- Options. Set to `false` to disable.
      options = {
        -- Basic options ('number', 'ignorecase', and many more)
        basic = true,
        -- Extra UI features ('winblend', 'cmdheight=0', ...)
        extra_ui = false,
        -- Presets for window borders ('single', 'double', ...)
        win_borders = "rounded",
      },
      -- Mappings. Set to `false` to disable.
      mappings = {
        -- Basic mappings (better 'jk', save with Ctrl+S, ...)
        basic = true,
        -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
        -- Supply empty string to not create these mappings.
        option_toggle_prefix = [[\]],
        -- Window navigation with <C-hjkl>, resize with <C-arrow>
        windows = true,
        -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
        move_with_alt = true,
      },
      -- Autocommands. Set to `false` to disable
      autocommands = {
        -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
        basic = true,
        -- Set 'relativenumber' only in linewise and blockwise Visual mode
        relnum_in_visual_mode = true,
      },
      silent = false,
    },
  }
}
