vim.lsp.enable("tailwindcss")

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          "tw=\\'([^\\']*)",
          "cva\\(([^)]*)\\)",
        },
      },
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
