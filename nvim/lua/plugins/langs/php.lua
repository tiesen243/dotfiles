vim.lsp.enable("intelephense")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "php" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "intelephense", "php-cs-fixer" },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" },
        blade = { "php_cs_fixer" },
        twig = { "php_cs_fixer" },
      },
      formatters = {
        php_cs_fixer = {
          env = { PHP_CS_FIXER_IGNORE_ENV = 1 },
        },
      },
    },
  },
}
