return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "lua" } },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = { ensure_installed = { "lua_ls" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
