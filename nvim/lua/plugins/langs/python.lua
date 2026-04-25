vim.lsp.enable({ "basedpyright", "ruff" })

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  disableOrganizeImports = true,
})

vim.lsp.config("ruff", {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = { settings = { logLevel = "error" } },
})

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
