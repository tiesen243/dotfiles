vim.lsp.enable("intelephense")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "php" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "intelephense", "php-cs-fixer" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" },
      },
      formatters = {
        php_cs_fixer = {
          env = { PHP_CS_FIXER_IGNORE_ENV = 1 },
        },
      },
    },
  },
}
