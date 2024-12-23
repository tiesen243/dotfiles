return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = { inlay_hint = { enable = true } },
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

            -- stylua: ignore start
            map("n", "<leader>cg", "<nop>", { desc = "Goto" })
            map("n", "<leader>cgd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto definition" })
            map("n", "<leader>cgr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Goto references" })
            map("n", "<leader>cgi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Goto implementation" })
            map("n", "<leader>cgy", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Goto t[y]pe definition" })
            map("n", "<leader>cgD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Goto declaration" })

            map("n", "<leader>cK", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover" })
            map("n", "<leader>ck", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })
            map("i", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })

            map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })
            map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
            map("n", "<leader>cR", "<cmd>lua Snacks.rename.rename_file()<cr>", { desc = "Rename File" })

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

          local settings = conf.settings or {}
          settings = {
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          }
          conf.settings = settings
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
