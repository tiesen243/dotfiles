vim.lsp.enable("vtsls")
vim.lsp.enable("eslint")

vim.lsp.config("vtsls", {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
      implementationsCodeLens = {
        enabled = true,
        showOnInterfaceMethods = true,
      },
      preferences = {
        importModuleSpecifier = "non-relative",
        autoImportSpecifierExcludeRegexes = {
          "@radix-ui",
          "next/dist",
          "next/router",
        },
        preferTypeOnlyAutoImports = true,
      },
    },
  },
})

vim.lsp.config("eslint", {
  settings = {
    autoFixOnSave = true,
  },
})

vim.filetype.add({
  pattern = {
    [".*%.ejs"] = "html",
  },
})

-- Yuki.format.register({
--   priority = 200,
--   name = "LspEslintFixAll",
--   active = function(bufnr)
--     local client = vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })[1]
--     return client ~= nil
--   end,
--   command = function(bufnr)
--     local client = vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })[1]
--     if client then
--       local diag = vim.diagnostic.get(bufnr)
--       if #diag > 0 then
--         vim.cmd("LspEslintFixAll")
--         vim.cmd("sleep 100m")
--       end
--     end
--   end,
-- })

local supported = {
  "blade",
  "css",
  "ejs",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "php",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "javascript", "typescript", "tsx" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "vtsls", "eslint-lsp", "prettier" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "prettier")
      end
    end,
  },
}
