vim.lsp.enable("qmlls")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "qmljs" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "qmlls" },
    },
  },
}
