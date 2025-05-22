vim.lsp.enable("jsonls")

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
      },
      format = { enable = false },
      validate = { enable = true },
    },
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json", "jsonc" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "json-lsp" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
      },
    },
  },
}
