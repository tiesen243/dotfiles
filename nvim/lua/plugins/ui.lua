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
      extra_groups = { "NormalFloat" },
      exclude_groups = { "CursorLine" },
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      require("transparent").clear_prefix("NeoTree")
      require("transparent").clear_prefix("WhichKey")
      require("transparent").clear_prefix("snack")
      require("transparent").clear_prefix("Telescope")
      require('transparent').clear_prefix("mason")
    end,
  },

  -- UI Input
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  -- Git Signs
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
}
