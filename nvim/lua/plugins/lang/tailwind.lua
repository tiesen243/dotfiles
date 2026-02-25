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
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "tailwindcss-language-server" } },
  },
}
