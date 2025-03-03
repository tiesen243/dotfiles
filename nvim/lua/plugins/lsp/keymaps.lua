local M = {}

M._keys = nil

M.get = function()
  if M._keys then
    return M._keys
  end

  -- stylua: ignore start
  M._keys = {
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "Goto References", opts = { nowait = true } },
    { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp", mode = { "i" } },
    { "K", vim.lsp.buf.hover, desc = "Hover doc" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", has = "codeAction", mode = { "n", "x" } },
    { "<leader>cd", vim.diagnostic.open_float, desc = "Inline Diagnostics" },
    { "<leader>cD", function() Snacks.picker.diagnostics() end, desc = "Workspace Diagnostics" },
    { "<leader>cf", vim.lsp.buf.format, desc = "Format" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Variable", has = "rename" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
    { "<leader>cs", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "<leader>ct", function() Snacks.picker.lsp_type_definitions() end, desc = "Type Definition" },
    { "<leader>cw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", has = "documentHighlight", cond = function() return Snacks.words.is_enabled() end },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous Reference", has = "documentHighlight", cond = function() return Snacks.words.is_enabled() end },
  }
  -- stylua: ignore end
end

M.has = function(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

M.on_attach = function(_, buffer)
  M.get()

  for _, key in pairs(M._keys) do
    local has = not key.has or M.has(buffer, key.has)
    local cond = not (key.cond == false or ((type(key.cond) == "function") and not key.cond()))

    if has and cond then
      local opts = {}
      opts.desc = key.desc
      opts.buffer = buffer
      opts.silent = opts.silent ~= false
      vim.keymap.set(key.mode or "n", key[1], key[2], opts)
    end
  end
end

return M
