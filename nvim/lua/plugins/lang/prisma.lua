return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "prisma" } },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = { ensure_installed = { "prismals" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        prisma = { "lsp" },
      },
    },
  },
}
