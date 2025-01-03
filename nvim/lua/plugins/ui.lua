return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent = vim.g.transparent_enabled },
  },
  {
    "xiyaowong/transparent.nvim",
    opts = {
      extra_groups = { "Pmenu", "NormalFloat", "Float" },
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
        theme = "auto",
        icons_enabled = true,
        disabled_filetypes = { statusline = { "snacks_dashboard", "neo-tree" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
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
          },
        },
        lualine_y = {
          { "selectioncount", padding = { left = 1, right = 1 } },
          { "searchcount",    padding = { left = 1, right = 1 } },
          { "progress",       padding = { left = 1, right = 0 }, separator = " " },
          { "location",       padding = { left = 0, right = 1 } },
        },
        -- lualine_z = {
        --   function()
        --     return " " .. os.date("%R")
        --   end,
        -- },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    },
  },

  -- UI Input
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
}
