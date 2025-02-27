return {
  -- add javascript, typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c", "cpp" } },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
      },
    },
  },

  -- add formatter
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "clang-format" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["c"] = { "clang-format" },
        ["cpp"] = { "clang-format" },
      },
    },
  },
}
