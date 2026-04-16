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
    { name = "mason", override = true },
    opts = { ensure_installed = { "oxfmt", "oxlint" } },
  },

  {
    { name = "conform", override = true },
    opts = function()
      local formatters_by_ft = {}
      for _, ft in ipairs(supported) do
        formatters_by_ft[ft] = formatters_by_ft[ft] or {}
        table.insert(formatters_by_ft[ft], "oxfmt")
        table.insert(formatters_by_ft[ft], "oxlint")
      end

      return {
        formatters_by_ft = formatters_by_ft,
      }
    end,
  },
}
