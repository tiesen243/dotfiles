return {
  -- Github theme
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = { transparent = vim.g.transparent_enabled },
  },
  {
    "xiyaowong/transparent.nvim",
    opts = function()
      require("transparent").clear_prefix("NvimTree")
      return { exclude_groups = { "CursorLine" } }
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        disabled_filetypes = { statusline = { "snacks_dashboard", "NvimTree" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          { "branch" },
          { "diff" },
        },
        lualine_c = { "diagnostics" },
        lualine_x = { "encoding", "fileformat", "rest" },
        lualine_y = {
          { "progress", padding = { left = 1, right = 0 }, separator = " " },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
    },
  },

  -- ui components
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

        sections = {
          { section = "header" },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
          { section = "keys", gap = 1, padding = 1, pane = 2 },
        },
      },

      words = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      styles = { notification = { wo = { wrap = true } } },
    },
  },
}
