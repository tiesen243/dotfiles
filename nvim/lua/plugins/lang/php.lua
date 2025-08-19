vim.lsp.enable("cssls")
vim.lsp.enable("html")
vim.lsp.enable("intelephense")

vim.filetype.add({
  pattern = {
    [".*%.tpl%.php"] = "blade",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "html", "php" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "css-lsp",
        "html-lsp",
        "intelephense",
      },
    },
  },
}
