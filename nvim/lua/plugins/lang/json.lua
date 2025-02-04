return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json5" } },
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
}
