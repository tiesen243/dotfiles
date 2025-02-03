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
}
