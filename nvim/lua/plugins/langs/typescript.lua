vim.lsp.enable("vtsls")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "javascript", "typescript", "tsx" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "vtsls" },
    },
  },
}
