vim.lsp.enable("vue_ls")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "vue" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "vue-language-server" },
    },
  },
}
