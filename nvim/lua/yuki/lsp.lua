local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

---@param client vim.lsp.Client
---@param bufnr number
M.on_attach = function(client, bufnr)
  local map = function(key, func, desc, mode)
    Yuki.utils.map(key, func, "LSP: " .. desc, { buffer = bufnr, mode = mode, noremap = true })
  end

  -- Disable default LSP keymaps
  pcall(vim.keymap.del, "n", "gra")
  pcall(vim.keymap.del, "n", "gri")
  pcall(vim.keymap.del, "n", "grn")
  pcall(vim.keymap.del, "n", "grr")
  pcall(vim.keymap.del, "n", "grt")
  pcall(vim.keymap.del, "n", "grx")

  -- stylua: ignore start
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
  map("gl", vim.diagnostic.open_float, "Line Diagnostic")
  map("gd", Snacks.picker.lsp_definitions, "Goto Definition")
  map("gD", Snacks.picker.lsp_declarations, "Goto Declaration")
  map("gr", Snacks.picker.lsp_references, "References")
  map("gI", Snacks.picker.lsp_implementations, "Goto Implementation")
  map("gy", Snacks.picker.lsp_type_definitions, "Goto T[y]pe Definition")

  map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("<leader>cd", Snacks.picker.diagnostics, "Diagnostics")
  map("<leader>cf", Yuki.format.format, "Format")
  map("<leader>cF", vim.lsp.buf.format, "Format (LSP)")
  map("<leader>cr", vim.lsp.buf.rename, "Rename (Variable)")
  map("<leader>cR", Snacks.rename.rename_file, "Rename (File)")
  map("<leader>cs", Snacks.picker.lsp_symbols, "Symbols")
  map("<leader>cx", vim.lsp.codelens.run, "Run Code Lens")

  map("]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
  map("[[", function() Snacks.words.jump(-vim.v.count1) end, "Previous Reference")
  -- stylua: ignore end

  if client.server_capabilities.inlayHintProvider then
    Snacks.toggle.inlay_hints():map("<leader>uh")
  end

  if client.server_capabilities.codeLensProvider then
    Snacks.toggle({
      name = "code_lens",
      get = vim.lsp.codelens.is_enabled,
      set = vim.lsp.codelens.enable,
    }):map("<leader>uc")
  end
end

---@param client vim.lsp.Client
---@param bufnr number
M.on_init = function(client, bufnr)
  if client:supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local status_ok, blink_cmp = pcall(require, "blink-cmp")
if status_ok then
  M.capabilities = blink_cmp.get_lsp_capabilities()
end

M.setup = function()
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

  vim.lsp.config("*", {
    capabilities = M.capabilities,
    on_init = M.on_init,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = require("yuki.utils").create_augroup("lsp_attach"),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end

      M.on_attach(client, ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = require("yuki.utils").create_augroup("lsp_progress"),
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
end

return M
