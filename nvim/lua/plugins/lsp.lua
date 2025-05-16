vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Yuki.icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = Yuki.icons.diagnostics.warn,
      [vim.diagnostic.severity.HINT] = Yuki.icons.diagnostics.hint,
      [vim.diagnostic.severity.INFO] = Yuki.icons.diagnostics.info,
    },
  },
  virtual_text = false,
  severity_sort = true,
})

return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "lua_ls" } },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("yuki-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Disable default LSP keymaps
          pcall(vim.keymap.del, "n", "gra")
          pcall(vim.keymap.del, "n", "gri")
          pcall(vim.keymap.del, "n", "grn")
          pcall(vim.keymap.del, "n", "grr")

          -- stylua: ignore start
          map("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
          map("gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
          map("gr", function() Snacks.picker.lsp_references() end, "References")
          map("gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
          map("<C-k>", function () vim.lsp.buf.signature_help() end, "Signature Help", "i")
          map("<C-d>", function () vim.diagnostic.open_float() end, "Cursor Diagnostic")
          map("<leader>ca", function () vim.lsp.buf.code_action() end, "Code Action")
          map("<leader>cd", function() Snacks.picker.diagnostics() end, "Diagnostics")
          map("<leader>cD", function() Snacks.picker.diagnostics() end,"Buffer Diagnostics")
          map("<leader>cf", function () Yuki.format.format() end, "Format")
          map("<leader>cr", function () vim.lsp.buf.rename() end, "Rename Variable")
          map("<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
          map("<leader>cs", function() Snacks.picker.lsp_symbols() end, "Symbols")
          map("<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")
          map("]]", function() Snacks.words.jump(vim.v.count1) end,  "Next Reference")
          map("[[", function() Snacks.words.jump(-vim.v.count1) end,  "Previous Reference")
          -- stylua: ignore end
        end,
      })

      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = { "stylua" },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      preset = "amongus",
    },
  },
}
