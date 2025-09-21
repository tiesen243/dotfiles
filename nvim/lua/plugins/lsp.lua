vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Yuki.configs.icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = Yuki.configs.icons.diagnostics.warn,
      [vim.diagnostic.severity.HINT] = Yuki.configs.icons.diagnostics.hint,
      [vim.diagnostic.severity.INFO] = Yuki.configs.icons.diagnostics.info,
    },
  },
  severity_sort = true,
  update_in_insert = false,
  underline = false,
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = vim.diagnostic.severity.WARN },
    spacing = 0,
    prefix = "",
    format = function(diagnostic)
      return string.format(
        "%s %s",
        Yuki.configs.icons.diagnostics[vim.diagnostic.severity[diagnostic.severity]:lower()],
        diagnostic.message
      )
    end,
  },
  float = {
    severity = { min = vim.diagnostic.severity.INFO },
    format = function(diagnostic)
      return string.format(
        "%s %s",
        Yuki.configs.icons.diagnostics[vim.diagnostic.severity[diagnostic.severity]:lower()],
        diagnostic.message
      )
    end,
    border = "rounded",
  },
})

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        on_attach = function(_, bufnr)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = bufnr, noremap = true, silent = true, desc = "LSP: " .. desc })
          end

          -- Disable default LSP keymaps
          pcall(vim.keymap.del, "n", "gra")
          pcall(vim.keymap.del, "n", "gri")
          pcall(vim.keymap.del, "n", "grn")
          pcall(vim.keymap.del, "n", "grr")
          pcall(vim.keymap.del, "n", "grt")

          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("L", vim.diagnostic.open_float, "Line Diagnostic")
          map("gd", Snacks.picker.lsp_definitions, "Goto Definition")
          map("gD", Snacks.picker.lsp_declarations, "Goto Declaration")
          map("gr", Snacks.picker.lsp_references, "References")
          map("gI", Snacks.picker.lsp_implementations, "Goto Implementation")
          map("gy", Snacks.picker.lsp_type_definitions, "Goto T[y]pe Definition")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cd", Snacks.picker.diagnostics, "Diagnostics")
          map("<leader>cD", Snacks.picker.diagnostics, "Buffer Diagnostics")
          map("<leader>cf", Yuki.format.format, "Format")
          map("<leader>cF", vim.lsp.buf.format, "Format (LSP)")
          map("<leader>cr", vim.lsp.buf.rename, "Rename Variable")
          map("<leader>cR", Snacks.rename.rename_file, "Rename File")
          map("<leader>cs", Snacks.picker.lsp_symbols, "Symbols")
          map("<leader>cS", Snacks.picker.lsp_workspace_symbols, "Workspace Symbols")
          -- stylua: ignore start
          map("]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
          map("[[", function() Snacks.words.jump(-vim.v.count1) end, "Previous Reference")
          -- stylua: ignore end
        end,
      })

      vim.api.nvim_create_autocmd("LspProgress", {
        group = Yuki.utils.create_augroup("lsp_progress"),
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                ---@diagnostic disable-next-line: undefined-field
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
      ensure_installed = {},
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
            vim.notify("Installing " .. tool .. "...", vim.log.levels.INFO, { title = "Mason" })
            p:install()
          end
        end
      end)
    end,
  },
}
