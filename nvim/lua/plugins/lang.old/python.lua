vim.lsp.enable({ "basedpyright", "ruff" })

vim.lsp.config("basedpyright", {
  disableOrganizeImports = true,
})

vim.lsp.config("ruff", {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = { settings = { logLevel = "error" } },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "python" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "basedpyright", "ruff" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
    },
  },
}
