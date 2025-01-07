return {
  {
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
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
              diagnostics = { globals = { "vim", "Snacks" } },
              completion = { workspaceWord = true, callSnippet = "Both" },
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
          single_file_support = true,
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
      },
    },
    config = function(_, opts)
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

        map("<C-k>", vim.lsp.buf.signature_help, "Signature help", { "i", "n" })
        map("<C-j>", vim.lsp.buf.hover, "[H]over doc", { "i", "n" })

        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("<leader>cd", vim.diagnostic.open_float, "Line [D]iagnostics")
        map("<leader>cf", vim.lsp.buf.format, "[F]ormat")
        map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
        map("<leader>cR", Snacks.rename.rename_file, "[R]ename file")
        map("<leader>cs", builtin.lsp_document_symbols, "Document [S]ymbols")
        map("<leader>ct", builtin.lsp_type_definitions, "[T]ype Definition")
        map("<leader>cw", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")

        if client and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable()
        end

        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end

      for type, icon in pairs(Yuki.icons.diagnostics) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local ensure_installed = vim.tbl_filter(function(server)
        return opts.servers[server].enabled
      end, vim.tbl_keys(opts.servers or {}))

      require("mason").setup({
        ui = {
          border = "rounded",
          icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            local server = opts.servers[server_name] or {}
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            server.capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
            server.on_attach = lsp_attach
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  -- Code context
  -- https://github.com/SmiteshP/nvim-navic
  {
    "SmiteshP/nvim-navic",
    opts = {
      click = true,
      highlight = true,
      icons = Yuki.icons.kind,
      lsp = { auto_attach = true },
    },
  },
  -- Java LSP
  -- https://github.com/mfussenegger/nvim-jdtls
  { "mfussenegger/nvim-jdtls", enabled = Yuki.lang.java, ft = "java" },
}
