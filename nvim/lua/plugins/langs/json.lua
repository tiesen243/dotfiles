vim.lsp.enable("jsonls")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "json5" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "json-lsp" },
    },
  },
}
