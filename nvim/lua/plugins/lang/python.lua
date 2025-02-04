return {
  -- add python to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {},
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = { settings = { logLevel = "error" } },
        },
      },
      setup = {
        ruff = function()
          Yuki.lsp.on_attach(function(client, _)
            client.server_capabilities.hoverProvider = false
          end, "ruff")
        end,
      },
    },
  },
}
