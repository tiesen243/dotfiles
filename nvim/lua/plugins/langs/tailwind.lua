vim.lsp.enable("tailwindcss")

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      classFunctions = { "cva", "cx", "cn", "tw" },
    },
  },
})

return {
  {
    { name = "mason", override = true },
    opts = { ensure_installed = { "tailwindcss-language-server" } },
  },
}
