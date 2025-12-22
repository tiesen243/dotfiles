vim.lsp.enable("oxlint")

vim.lsp.config("oxlint", {})

local supported = {
  "css",
  "ejs",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "json5",
  "less",
  "markdown",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "oxlint" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "oxfmt")
        table.insert(opts.formatters_by_ft[ft], "oxlint")
      end
    end,
  },
}
