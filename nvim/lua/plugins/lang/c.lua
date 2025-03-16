return {
  -- add c, cpp to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c", "cpp" } },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--offset-encoding=utf-16",
            "--background-index",
            "-j=12",
            "--query-driver=**",
            "--clang-tidy",
            "--all-scopes-completion",
            "--cross-file-rename",
            "--completion-style=detailed",
            "--header-insertion-decorators",
            "--header-insertion=iwyu",
            "--pch-storage=memory",
            "--suggest-missing-includes",
          },
        },
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
