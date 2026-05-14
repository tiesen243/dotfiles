vim.lsp.enable("lua_ls")

return {
  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "lua-language-server", "stylua" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
