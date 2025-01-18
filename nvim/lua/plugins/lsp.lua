return {
  {
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      inlay_hints = { enabled = true },
      codelens = { enabled = true },
      capabilities = { workspace = { fileOperations = { didRename = true, willRename = true } } },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Yuki.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = Yuki.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = Yuki.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = Yuki.icons.diagnostics.Info,
          },
        },
      },
      servers = {
        eslint = { enabled = Yuki.lang.react },
        lua_ls = {
          enabled = true,
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim', 'Snacks' } },
              doc = { privateName = { '^_' } },
              -- stylua: ignore
              hint = { enable = true, setType = false, paramType = true, paramName = "Disable", semicolon = "Disable", arrayIndex = "Disable" },
            },
          },
        },
        basedpyright = { enabled = Yuki.lang.python },
        jdtls = { enabled = Yuki.lang.java },
        prismals = { enabled = Yuki.lang.react },
        ruff = { enabled = Yuki.lang.python },
        tailwindcss = { enabled = Yuki.lang.react },
        vtsls = {
          enabled = Yuki.lang.react,
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = 'literals' },
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

      -- Diagnostic icons
      if type(opts.diagnostics.signs) ~= 'boolean' then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub('^%l', string.upper)
          name = 'DiagnosticSign' .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
        end
      end

      -- LSP virtual text
      if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
        opts.diagnostics.virtual_text.prefix = vim.fn.has 'nvim-0.10.0' == 0 and '●'
            or function(diagnostic)
              local icons = Yuki.icons.diagnostics
              for d, icon in pairs(icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                  return icon
                end
              end
            end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local ensure_installed = vim.tbl_filter(function(server)
        return opts.servers[server].enabled
      end, vim.tbl_keys(opts.servers or {}))

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
            server.capabilities = vim.tbl_deep_extend('force', capabilities,
              require('blink.cmp').get_lsp_capabilities(opts.capabilities))

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
  { 'j-hui/fidget.nvim',       opts = { notification = { window = { winblend = 0 } } } },

  -- Java LSP
  -- https://github.com/mfussenegger/nvim-jdtls
  { 'mfussenegger/nvim-jdtls', enabled = Yuki.lang.java },
}
