return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local on_attach = function(client, _)
        vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })

        vim.keymap.set("n", "<leader>lg", "<nop>", { desc = "LSP GoTo" })
        vim.keymap.set("n", "<leader>lgd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto Definition" })
        vim.keymap.set("n", "<leader>lgr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "References" })
        vim.keymap.set(
          "n",
          "<leader>lgI",
          "<cmd>lua vim.lsp.buf.implementation()<cr>",
          { desc = "Goto Implementation" }
        )
        vim.keymap.set(
          "n",
          "<leader>lgy",
          "<cmd>lua vim.lsp.buf.type_definition()<cr>",
          { desc = "Goto Type Definition" }
        )
        vim.keymap.set("n", "<leader>lgD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Goto Declaration" })

        vim.keymap.set("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover Doc" })
        vim.keymap.set("n", "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature Help" })

        vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
        vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
        vim.keymap.set("n", "<leader>lR", "<cmd>lua Snacks.rename.rename_file()<cr>", { desc = "Rename File" })

        if Snacks.words.is_enabled() then
          vim.keymap.set("n", "]]", "<cmd>lua Snacks.words.jump(vim.v.count1)<cr>", { desc = "Next Word" })
          vim.keymap.set("n", "[[", "<cmd>lua Snacks.words.jump(-vim.v.count1)<cr>", { desc = "Previous Word" })
        end

        if client.name == "ts_ls" then
          vim.keymap.set("n", "<C-o>", "<cmd>OrganizeImports<cr>", { desc = "Organize Imports" })
        end
      end

      local servers = { "lua_ls", "ts_ls", "emmet_ls", "tailwindcss", "eslint", "prismals" }
      for _, server_name in ipairs(servers) do
        local conf = {
          on_attach = on_attach,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
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

  -- auto install server
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
