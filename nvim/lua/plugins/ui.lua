return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night", transparent = vim.g.transparent_enabled },
  },
  {
    "xiyaowong/transparent.nvim",
    opts = {
      extra_groups = { "Pmenu", "NormalFloat", "Float", "FloatBorder" },
      exclude_groups = { "CursorLine" },
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("WhichKey")
      require("transparent").clear_prefix("snack")
      require("transparent").clear_prefix("Telescope")
      require("transparent").clear_prefix("mason")
      require("transparent").clear_prefix("BlinkCmpDoc")
    end,
  },

  -- Statusline
  -- https://github.com/nvim-lualine/lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = Yuki.colorcheme,
        icons_enabled = true,
        disabled_filetypes = { "snacks_dashboard", "neo-tree" },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
      },
      winbar = {
        lualine_b = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
        },
        lualine_c = {
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
      },
      inactive_winbar = {
        lualine_b = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return " " .. str
            end,
          },
        },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = Yuki.icons.diagnostics.Error,
              warn = Yuki.icons.diagnostics.Warn,
              info = Yuki.icons.diagnostics.Info,
              hint = Yuki.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true,   separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 3 },
        },
        lualine_x = {
          {
            "diff",
            symbols = {
              added = Yuki.icons.git.added,
              modified = Yuki.icons.git.modified,
              removed = Yuki.icons.git.removed,
            },
            sources = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          { "selectioncount", padding = { left = 1, right = 1 } },
          { "searchcount",    padding = { left = 1, right = 1 } },
        },
        lualine_y = {
          { "progress", padding = { left = 1, right = 0 }, separator = " " },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          { Yuki.get_battery_state, padding = { left = 1, right = 0 }, separator = " " },
          { Yuki.get_time,          padding = { left = 0, right = 1 } },
        },
      },
      extensions = { "neo-tree", "lazy", "fzf", "quickfix" },
    },
  },

  -- UI Input
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  {
    "MunsMan/kitty-navigator.nvim",
    build = {
      "cp navigate_kitty.py ~/.config/kitty",
      "cp pass_keys.py ~/.config/kitty",
    },
    keys = {
      -- stylua: ignore start
      { "<C-h>", function() require("kitty-navigator").navigateLeft() end,  desc = "Move left a Split",  mode = { "n" } },
      { "<C-j>", function() require("kitty-navigator").navigateDown() end,  desc = "Move down a Split",  mode = { "n" } },
      { "<C-k>", function() require("kitty-navigator").navigateUp() end,    desc = "Move up a Split",    mode = { "n" } },
      { "<C-l>", function() require("kitty-navigator").navigateRight() end, desc = "Move right a Split", mode = { "n" } },
    },
  },
}
