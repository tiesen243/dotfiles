vim.lsp.enable("vue_ls")

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
  languages = { "vue" },
  configNamespace = "typescript",
  enableForWorkspaceTypeScriptVersions = true,
}

vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = { vue_plugin },
      },
    },
  },
})

vim.lsp.config("vue_ls", {})

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "vue" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "vue-language-server" },
    },
  },
}
