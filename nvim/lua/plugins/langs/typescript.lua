vim.lsp.enable("vtsls")

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
      referencesCodeLens = {
        enabled = true,
      },
      preferences = {
        importModuleSpecifier = "non-relative",
        autoImportSpecifierExcludeRegexes = {
          "@base-ui/react",
          "radix-ui",
          "next/dist",
          "next/router",
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    if not vim.lsp.commands["editor.action.showReferences"] then
      vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
        local locations = command.arguments[3]
        if locations and #locations > 0 then
          Snacks.picker.lsp_references({
            items = locations,
          })
        end
      end
    end
  end,
})

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "javascript", "typescript", "tsx" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "vtsls" },
    },
  },
}
