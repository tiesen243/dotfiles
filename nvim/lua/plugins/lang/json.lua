return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json", "jsonc" } },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                  url = "http://json.schemastore.org/tsconfig",
                },
              },
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },

  -- setup formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" }
      },
    },
  },

}
