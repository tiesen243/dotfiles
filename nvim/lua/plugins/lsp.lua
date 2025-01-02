return {
  {
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    opts = { inlay_hints = { enabled = true } },
    config = function()
      require("mason").setup({
        ui = {
          icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
          border = "rounded",
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local lsp_attach = function(client, bufnr)
        local map = function(key, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
        end

        local builtin = require("telescope.builtin")
        map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gr", builtin.lsp_references, "[G]oto [R]eferences")
        map("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")

        map("<leader>ct", builtin.lsp_type_definitions, "[T]ype Definition")
        map("<leader>cs", builtin.lsp_document_symbols, "Document [S]ymbols")
        map("<leader>cw", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")
        map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
        map("<leader>cR", Snacks.rename.rename_file, "[R]ename file")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        if not client.name == "tailwindcss" then
          map("<leader>cd", vim.diagnostics.open_float, "Line [D]iagnostics")
        end

        if Snacks.words.is_enabled() then
          map("n", "]]", function()
            Snacks.words.jump(vim.v.count1, true)
          end, { desc = "Next word" })
          map("n", "[[", function()
            Snacks.words.jump(-vim.v.count1, true)
          end, { desc = "Previous word" })
        end

        if client and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable()
        end
      end

      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local servers = {
        emmet_ls = {},
        eslint = {},
        jdtls = {},
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = true },
              diagnostics = { globals = { "vim", "Snacks" } },
            },
          },
        },
        pyright = {},
        prismals = {},
        ruff = {},
        tailwindcss = {},
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
      }

      local ensure_installed = {}
      for key, _ in pairs(servers) do
        table.insert(ensure_installed, key)
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.on_attach = lsp_attach
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  { "mfussenegger/nvim-jdtls" },
}
