vim.lsp.enable("tailwindcss")

return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "tailwindcss-language-server" } },
  },
}
