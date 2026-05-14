vim.lsp.enable("jdtls")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "java" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "jdtls" },
    },
  },

  {
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    opts = {
      postinstall = function() end,
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        java = { "clang-format" },
      },
    },
  },
}
