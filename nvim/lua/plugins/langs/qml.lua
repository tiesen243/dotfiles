vim.lsp.enable("qmlls")

vim.lsp.config("qmlls", {
  cmd = { "qmlls", "-E" },
})

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
