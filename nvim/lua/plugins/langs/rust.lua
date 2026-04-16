vim.lsp.enable("rust_analyzer")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "rust" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "rust-analyzer" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
