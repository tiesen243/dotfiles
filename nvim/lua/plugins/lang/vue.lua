vim.lsp.enable("vue_ls")

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
  languages = { "vue" },
  configNamespace = "typescript",
  enableForWorkspaceTypeScriptVersions = true,
}

vim.lsp.config("vtsls", {
  settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin } } } },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
})

vim.lsp.config("vue_ls", {})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "vue" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "vue-language-server" } },
  },
}
