return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
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
        local conf = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(client, bufnr)
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- stylua: ignore start
            opts.desc = "Show LSP References"
            map("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
            opts.desc = "Go to declaration"
            map("n", "gD", vim.lsp.buf.declaration, opts)
            opts.desc = "Go to definitions"
            map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
            opts.desc = "Go to type implementations"
            map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

            opts.desc = "Show hover doc"
            map("n", "<leader>ch", vim.lsp.buf.hover, opts)
            opts.desc = "Show signature help"
            map("n", "<leader>ck", vim.lsp.buf.signature_help, opts)
            map("i", "<c-k>", vim.lsp.buf.signature_help, opts)

            opts.desc = "Show code actions"
            map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            opts.desc = "Rename"
            map("n", "<leader>cr", vim.lsp.buf.rename, opts)
            opts.desc = "Rename File"
            map("n", "<leader>cR", Snacks.rename.rename_file, opts)
            opts.desc = "Show buffer diagnostics"
            map("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
            if not client.name == 'tailwindcss' then
              opts.desc = "Show line diagnostics"
              map("n", "<leader>cd", vim.diagnostics.open_float, opts)
            end

            if Snacks.words.is_enabled() then
              map("n", "]]", function() Snacks.words.jump(vim.v.count1, true) end, { desc = "Next word" })
              map("n", "[[", function() Snacks.words.jump(-vim.v.count1, true) end, { desc = "Previous word" })
            end

            if client.name == "ts_ls" then
              vim.keymap.set("n", "<C-o>", "<cmd>OrganizeImports<cr>", { desc = "Organize Imports" })
            end

            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              vim.api.nvim_set_hl(0, "LspInlayHint", { bg = '#484F58', fg = '#8B949E' })
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

  -- Package manager
  -- https://github.com/williamboman/mason.nvim
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
}
