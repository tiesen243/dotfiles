vim.lsp.enable({ "basedpyright", "ruff" })

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "python" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "basedpyright", "ruff" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
    },
  },
}
