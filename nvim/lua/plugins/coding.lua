return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", run = "make install_jsregexp" },
    },
    config = function()
      local cmp = require("cmp")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = { completion = cmp.config.window.bordered() },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-S-Space>"] = cmp.mapping.close(),

          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        },

        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
        formatting = {
          format = require("lspkind").cmp_format({
            maxwidth = 50,
            ellipsis_char = "",
            preset = "codicons",
            mode = "symbol_text",
          }),
        },
      })

      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local formatters = null_ls.builtins.formatting
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          -- Lua
          formatters.stylua,

          -- Web
          formatters.prettier,

          -- Python
          formatters.black,
        },

        -- Format on save
        debug = false,
        on_attach = function(client, bufnr)
          local async_formatting = function()
            bufnr = bufnr or vim.api.nvim_get_current_buf()

            vim.lsp.buf_request(
              bufnr,
              "textDocument/formatting",
              vim.lsp.util.make_formatting_params({}),
              function(err, res, ctx)
                if err then
                  local err_msg = type(err) == "string" and err or err.message
                  -- you can modify the log message / level (or ignore it completely)
                  vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
                  return
                end

                -- don't apply results if buffer is unloaded or has been modified
                if
                    not vim.api.nvim_buf_is_loaded(bufnr)
                    or vim.api.nvim_buf_get_option(bufnr, "modified")
                then
                  return
                end

                if res then
                  local client = vim.lsp.get_client_by_id(ctx.client_id)
                  vim.lsp.util.apply_text_edits(
                    res,
                    bufnr,
                    client and client.offset_encoding or "utf-16"
                  )
                  vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("silent noautocmd update")
                  end)
                end
              end
            )
          end

          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePost", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                async_formatting(bufnr)
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "razak17/tailwind-fold.nvim",
    lazy = false,
    keys = { { "<C-f>", "<cmd>TailwindFoldToggle<cr>", desc = "Toggle Tailwind Fold" } },
    config = function()
      require("tailwind-fold").setup()
    end,
  },
  {
    "ggandor/lightspeed.nvim",
    config = function()
      require("lightspeed").setup({
        ignore_case = true,
      })

      vim.cmd("autocmd ColorScheme * lua require('lightspeed').init_highlight(true)")
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = { "github/copilot.vim" },
    keys = {
      { "<leader>c",  "<nop>",                             desc = "Copilot" },
      { "<leader>ct", "<cmd>CopilotChatToggle<cr>",        desc = "Toggle Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>",       desc = "Explain code" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>",        desc = "Review code" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>",           desc = "Fix bug" },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>",      desc = "Optimize code" },
      { "<leader>cd", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Fix Diagnostic" },
      { "<leader>cc", "<cmd>CopilotChatCommit<cr>",        desc = "Suggest commit message" },
      { "<leader>cs", "<cmd>CopilotChatCommitStaged<cr>",  desc = "Suggest commit stage message" },
      {
        "<leader>cp",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    },
    config = function()
      require("CopilotChat").setup({
        window = { layout = "float", title = "Copilot Chat" },
        mappings = { complete = { insert = "" } },
      })
    end,
  },
}
