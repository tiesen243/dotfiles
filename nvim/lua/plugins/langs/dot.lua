vim.lsp.enable("bashls")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "bash", "git_config" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "bash-language-server", "shfmt" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },
}
