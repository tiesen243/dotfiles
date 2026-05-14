vim.lsp.enable("tailwindcss")

return {
  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "tailwindcss-language-server" },
    },
  },
}
