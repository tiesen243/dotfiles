return {
  {
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        emmet_ls = { enabled = Yuki.lang.react },
        eslint = { enabled = Yuki.lang.react },
        lua_ls = {
          enabled = true,
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim', 'Snacks' } },
              -- stylua: ignore
              hint = { enable = true, setType = false, paramType = true, paramName = "Disable", semicolon = "Disable", arrayIndex = "Disable" },
            },
          },
        },
        basedpyright = { enabled = Yuki.lang.python },
        prismals = { enabled = Yuki.lang.react },
        ruff = { enabled = Yuki.lang.python },
        tailwindcss = { enabled = Yuki.lang.react },
        vtsls = {
          enabled = Yuki.lang.react,
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = 'all' },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local utils = require 'core.utils'

      for type, icon in pairs(Yuki.icons.diagnostics) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      local ensure_installed = vim.tbl_filter(function(server)
        return opts.servers[server].enabled
      end, vim.tbl_keys(opts.servers or {}))
      vim.list_extend(ensure_installed, {
        Yuki.lang.java and 'jdtls',
      })

      require('mason').setup {
        ui = {
          border = 'rounded',
          icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            local server = opts.servers[server_name] or {}
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            server, capabilities = vim.tbl_deep_extend('force', capabilities,
              require('cmp_nvim_lsp').default_capabilities())
            server.on_attach = utils.lsp_attach
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- Code context
  -- https://github.com/SmiteshP/nvim-navic
  {
    'SmiteshP/nvim-navic',
    opts = {
      click = true,
      highlight = true,
      icons = Yuki.icons.kinds,
      lsp = { auto_attach = true },
    },
  },

  -- LSP Progress
  -- https://github.com/j-hui/fidget.nvim
  {
    'j-hui/fidget.nvim',
    opts = { notification = { window = { border = 'rounded', winblend = 0 } } },
  },

  -- Java LSP
  -- https://github.com/mfussenegger/nvim-jdtls
  { 'mfussenegger/nvim-jdtls', enabled = Yuki.lang.java },
}
