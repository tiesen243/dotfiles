return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
            border = "rounded",
          },
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")

      local servers = {
        "lua_ls",
        "ts_ls",
        "eslint",
        "emmet_ls",
        "tailwindcss",
        "prismals",
        "typos_lsp",
      }
      for _, server_name in ipairs(servers) do
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities =
            vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        local conf = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- stylua: ignore start
            opts.desc = "[G]oto [D]efinitions"
            map("n", "gd", require('telescope.builtin').lsp_definitions, opts)
            opts.desc = '[G]oto [D]eclaration'
            map("n", "gD", vim.lsp.buf.declaration, opts)
            opts.desc = "'[G]oto [R]eferences'"
            map("n", "gr", require('telescope.builtin').lsp_references, opts)
            opts.desc = '[G]oto [I]mplementation'
            map("n", "gi", require('telescope.builtin').lsp_implementations, opts)

            opts.desc = "[C]ode [H]over doc"
            map("n", "<leader>ch", vim.lsp.buf.hover, opts)
            opts.desc = "[C]ode signature help"
            map("n", "<leader>ck", vim.lsp.buf.signature_help, opts)
            map("i", "<c-k>", vim.lsp.buf.signature_help, opts)
            opts.desc = "[C]ode document [S]ymbols"
            map("n", "<leader>cs", require('telescope.builtin').lsp_document_symbols, opts)

            opts.desc = "[C]ode [A]ctions"
            map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            opts.desc = "[C]ode [R]ename"
            map("n", "<leader>cr", vim.lsp.buf.rename, opts)
            opts.desc = "[C]ode [R]ename file"
            map("n", "<leader>cR", Snacks.rename.rename_file, opts)
            opts.desc = '[T]ype Definitions'
            map("n", "<leader>ct", require('telescope.builtin').lsp_type_definitions, opts)
            opts.desc = "[C]ode buffer [D]iagnostics"
            map("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
            if not client.name == 'tailwindcss' then
              opts.desc = "[C]ode line [D]iagnostics"
              map("n", "<leader>cd", vim.diagnostics.open_float, opts)
            end

            if Snacks.words.is_enabled() then
              map("n", "]]", function() Snacks.words.jump(vim.v.count1, true) end, { desc = "Next word" })
              map("n", "[[", function() Snacks.words.jump(-vim.v.count1, true) end, { desc = "Previous word" })
            end

            if client.name == "ts_ls" then
              vim.keymap.set("n", "<C-o>", "<cmd>OrganizeImports<cr>", { desc = "Organize Imports" })
            end
          end,
        }

        local signs = { Error = "", Warn = "", Hint = "", Info = "" }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        if server_name == "ts_ls" then
          local commands = conf.commands or {}
          commands.OrganizeImports = {
            function()
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
            end,
            description = "Organize imports",
          }
          conf.commands = commands
        end

        if server_name == "lua_ls" then
          local settings = conf.settings or {}
          settings = { Lua = { diagnostics = { globals = { "vim", "Snacks" } } } }
          conf.settings = settings
        end

        lspconfig[server_name].setup(conf)
      end
    end,
  },
}
