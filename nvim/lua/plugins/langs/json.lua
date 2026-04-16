vim.filetype.add({
  pattern = {
    [".*/typescript/.*%.json"] = "jsonc",
    [".*/oxc/.*%.json"] = "jsonc",
  },
})

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
          fileMatch = { "composer.json" },
          url = "https://getcomposer.org/schema.json",
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
      },
      format = { enable = false },
      validate = { enable = true },
    },
    jsonc = {
      schemas = {
        fileMatch = { "tsconfig.json", "tsconfig.*.json" },
        url = "http://json.schemastore.org/tsconfig",
      },
      format = { enable = false },
      validate = { enable = true },
    },
  },
})

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = { ensure_installed = { "json5" } },
  },

  {
    { name = "mason", override = true },
    opts = { ensure_installed = { "json-lsp" } },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
      },
    },
  },
}
