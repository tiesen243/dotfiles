return {

  -- nightfox theme
  -- https://github.com/EdenEast/nightfox.nvim
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      vim.cmd.colorscheme("carbonfox")

      local palette = require("nightfox.palette").load("carbonfox")
      vim.api.nvim_set_hl(0, "NavicSeparator", { fg = palette.fg2 })
      vim.api.nvim_set_hl(0, "NavicText", { fg = palette.fg2 })

      return {
        options = {
          transparent = vim.g.transparent_enabled,
          colorblind = {
            enable = true,
            severity = {
              protan = 0.3,
              deutan = 0.6,
            },
          },
        },
      }
    end,
  },

  -- transparent nvim
  -- https://github.com/xiyaowong/transparent.nvim
  {
    "xiyaowong/transparent.nvim",
    opts = function()
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("lualine_c")
      require("transparent").clear_prefix("lualine_x_diff")
      require("transparent").clear_prefix("lualine_transitional_lualine_b")

      return {
        extra_groups = {
          "NormalFloat",
          "Float",
          "NeoTreeNormal",
          "WhichKeyNormal",
          "WhichKeyBorder",
          "SnacksPickerBorder",
          "SnacksPickerInputBorder",
        },
        exclude_groups = { "CursorLine", "NeoTreeCursorLine" },
      }
    end,
  },

  -- statusline
  -- https://github.com/nvim-lualine/lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        always_divide_middle = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "snacks_dashboard", "neo-tree" },
      },
      sections = {
        -- stylua: ignore
        lualine_a = { { 'mode', fmt = function(str) return ' ' .. str end } },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = Yuki.configs.icons.diagnostics.Error,
              warn = Yuki.configs.icons.diagnostics.Warn,
              info = Yuki.configs.icons.diagnostics.Info,
              hint = Yuki.configs.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          {
            function()
              local navic = require("nvim-navic")
              return navic.get_location()
            end,
            cond = function()
              local navic = require("nvim-navic")
              return navic.is_available()
            end,
          },
        },
        lualine_x = {
          {
            "diff",
            symbols = {
              added = Yuki.configs.icons.git.added,
              modified = Yuki.configs.icons.git.modified,
              removed = Yuki.configs.icons.git.removed,
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
          { "searchcount", padding = { left = 1, right = 1 } },
        },
        lualine_y = {
          { "progress", padding = { left = 1, right = 0 }, separator = " " },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          -- { Yuki.actions.get_battery_state, padding = { left = 1, right = 0 }, separator = " " },
          { Yuki.actions.get_time },
        },
      },
    },
  },
}
