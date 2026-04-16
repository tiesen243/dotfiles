vim.lsp.enable("prismals")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "prisma" },
    },
  },

  {
    { name = "mason", override = true },
    opts = { ensure_installed = { "prisma-language-server" } },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        prisma = { "lsp" },
      },
    },
  },
}
