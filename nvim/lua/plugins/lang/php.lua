vim.lsp.enable("intelephense")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "php" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "intelephense" } },
  },
}
