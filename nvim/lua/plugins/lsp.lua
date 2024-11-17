return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local capabilities = cmp_nvim_lsp.default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      cmp_nvim_lsp.setup({ capabilities = capabilities })

      local on_attach = function(client, _)
        local opts = function(desc)
          return { noremap = true, silent = true, expr = false, nowait = false, desc = desc }
        end

        vim.keymap.set("n", "<leader>lR", "<cmd>LspRestart<cr>", opts("Restart LSP"))

        vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", opts("Rename"))
        vim.keymap.set("n", "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", opts("Hover docs"))
        vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", opts("Code action"))

        vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<cr>", opts("Outline"))
        vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<cr>", opts("References"))
        vim.keymap.set("n", "<leader>lF", "<cmd>lua vim.lsp.buf.format()<cr>", opts("Format"))
        vim.keymap.set("n", "<leader>lp", "<cmd>Lspsaga peek_definition<cr>", opts("Peak definition"))
        vim.keymap.set("n", "<leader>lg", "<cmd>Lspsaga goto_definition<cr>", opts("Goto definition"))

        vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts("Prev diagnostic"))
        vim.keymap.set("n", "<leader>lD", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts("Next diagnostic"))

        if client.name == "ts_ls" then
          vim.keymap.set("n", "<C-o>", "<cmd>OrganizeImports<cr>", opts("Organize imports"))
        end
      end

      local servers = { "lua_ls", "ts_ls", "emmet_ls", "tailwindcss", "eslint", "prismals" }
      for _, server_name in ipairs(servers) do
        local conf = {
          on_attach = on_attach,
          capabilities = capabilities,
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
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        lightbulbs = { enabled = false },
        rename = { keys = { quit = "<C-d>" } },
        finder = { default = "ref", keys = { tabnew = "<cr>" } },
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = true,
        },
        outline = {
          close_after_jump = false,
          keys = { jump = "<cr>" },
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim", "jay-babu/mason-null-ls.nvim" },
    config = function()
      require("mason").setup({
        ui = {
          icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
          border = "rounded",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "eslint",
          "emmet_ls",
          "prismals",
          "tailwindcss",
        },
      })

      require("mason-null-ls").setup({
        ensure_installed = {
          "stylua",
          "prettier",
        },
      })
    end,
  },
}
