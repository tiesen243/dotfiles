vim.lsp.enable("kotlin_lsp")

vim.lsp.config("kotlin_lsp", {})

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "kotlin" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "kotlin-lsp", "ktfmt" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        kotlin = { "ktfmt" },
      },
    },
  },
}
