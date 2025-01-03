return {
  {
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        emmet_ls = { enabled = Yuki.lang.react },
        eslint = { enabled = Yuki.lang.react },
        jdtls = { enabled = Yuki.lang.java },
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = true },
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim", "Snacks" } },
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

        map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
        map("<C-h>", vim.lsp.buf.hover, "[H]over doc", "i")
        map("<leader>ck", vim.lsp.buf.signature_help, "Signature help")
        map("<leader>ch", vim.lsp.buf.hover, "[H]over doc")

        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("<leader>cd", vim.diagnostic.open_float, "Line [D]iagnostics")
        map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
        map("<leader>cR", Snacks.rename.rename_file, "[R]ename file")
        map("<leader>cs", builtin.lsp_document_symbols, "Document [S]ymbols")
        map("<leader>ct", builtin.lsp_type_definitions, "[T]ype Definition")
        map("<leader>cw", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")

        if client.name == "basedpyright" then
          map("<leader>cv", "<cmd>VenvSelect<CR>", "Select [V]irtualenv")
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

        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end

      for type, icon in pairs(Yuki.icons.diagnostics) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local ensure_installed = vim.tbl_keys(opts.servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",                       -- Used to format Lua code
        Yuki.lang.react and "prettier", -- Used to format JavaScript, TypeScript, CSS, and JSON
        "shfmt",                        -- Used to format Shell script
      })

      require("mason").setup({
        ui = {
          icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
          border = "rounded",
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
        auto_update = true,
      })

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local server = opts.servers[server_name] or {}
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          server.capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
          server.on_attach = lsp_attach
          require("lspconfig")[server_name].setup(server)
        end,
        ["jdtls"] = function() end,
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = { notification = { window = { winblend = 0, border = "rounded" } } },
  },
  {
    "linux-cultist/venv-selector.nvim",
    enabled = Yuki.lang.python,
    event = "VeryLazy",
    branch = "regexp",
    opts = { auto_refresh = true, name = { "venv", ".venv" } },
  },
  { "mfussenegger/nvim-jdtls", enabled = Yuki.lang.java },
  { "SmiteshP/nvim-navic" },
}
