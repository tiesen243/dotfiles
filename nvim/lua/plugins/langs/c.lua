vim.lsp.enable("clangd")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = { ensure_installed = { "c", "cpp" } },
  },

  {
    { name = "mason", override = true },
    opts = { ensure_installed = { "clangd", "clang-format" } },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
}
