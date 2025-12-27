vim.lsp.enable("tailwindcss")

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          "cva\\(([^)]*)\\)",
          "cn\\(([^)]*)\\)",
          "tw=\\'([^\\']*)",
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
