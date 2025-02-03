return {
  -- tokyonight theme
  -- https://github.com/folke/tokyonight.nvim
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night", transparent = vim.g.transparent_enabled },
  },

  -- Transparent nvim
  -- https://github.com/xiyaowong/transparent.nvim
  {
    "xiyaowong/transparent.nvim",
    opts = {
      extra_groups = { "NormalFloat", "Float" },
      exclude_groups = { "CursorLine" },
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("WhichKey")
      require("transparent").clear_prefix("snack")
      require("transparent").clear_prefix("Telescope")
      require("transparent").clear_prefix("mason")
    end,
  },

  -- Statusline
  -- https://github.com/nvim-lualine/lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        always_divide_middle = true,
        theme = Yuki.colorcheme or "auto",
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
              error = Yuki.icons.diagnostics.Error,
              warn = Yuki.icons.diagnostics.Warn,
              info = Yuki.icons.diagnostics.Info,
              hint = Yuki.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true,   separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
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
          { Yuki.actions.get_battery_state, padding = { left = 1, right = 0 }, separator = " " },
          { Yuki.actions.get_time,          padding = { left = 0, right = 1 } },
        },
      },
    },
  },
}
