local M = {}

M.on_attach = function(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

M.attach = function(_, buffer)
  local builtin = require("telescope.builtin")
  -- stylua: ignore start
  local keys = {
    { '<leader>cI', '<cmd>LspInfo<cr>',                    desc = "Lsp Info" },
    { 'gd',         builtin.lsp_definitions,               desc = '[G]oto [D]efinition',       has = 'definition' },
    { 'gD',         vim.lsp.buf.declaration,               desc = '[G]oto [D]eclaration' },
    { 'gr',         builtin.lsp_references,                desc = '[G]oto [R]eferences',       opts = { nowait = true } },
    { 'gi',         builtin.lsp_implementations,           desc = '[G]oto [I]mplementation' },
    { "gy",         vim.lsp.buf.type_definition,           desc = "[G]oto T[y]pe Definition" },
    { '<c-k>',      vim.lsp.buf.signature_help,            desc = 'Signature help',            has = 'signatureHelp',                                            mode = { 'i' } },
    { 'gk',         vim.lsp.buf.signature_help,            desc = 'Signature help',            has = 'signatureHelp' },
    { 'K',          vim.lsp.buf.hover,                     desc = 'Hover doc',                 mode = { 'i' } },
    { '<leader>ca', vim.lsp.buf.code_action,               desc = '[C]ode [A]ction',           has = 'codeAction',                                               mode = { 'n', 'x' } },
    { '<leader>cd', vim.diagnostic.open_float,             desc = '[C]ode [D]iagnostics' },
    { '<leader>cf', vim.lsp.buf.format,                    desc = '[C]ode [F]ormat' },
    { '<leader>cr', vim.lsp.buf.rename,                    desc = '[C]ode [R]ename',           has = 'rename' },
    { '<leader>cR', Snacks.rename.rename_file,             desc = '[C]ode [R]ename file',      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
    { '<leader>cs', builtin.lsp_document_symbols,          desc = '[C]ode Document [S]ymbols' },
    { '<leader>ct', builtin.lsp_type_definitions,          desc = '[C]ode [T]ype Definition' },
    { '<leader>cw', builtin.lsp_dynamic_workspace_symbols, desc = '[C]ode [W]orkspace Symbols' },
    {
      ']]',
      function() Snacks.words.jump(vim.v.count1) end,
      desc = 'Next Reference',
      has = 'documentHighlight',
      cond = function() return Snacks.words.is_enabled() end,
    },
    {
      '[[',
      function() Snacks.words.jump(-vim.v.count1) end,
      desc = 'Previous Reference',
      has = 'documentHighlight',
      cond = function() return Snacks.words.is_enabled() end,
    },
  }

  for _, k in ipairs(keys) do
    local has = not k.has or Yuki.actions.has(buffer, k.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == 'function') and not keys.cond()))
    local otps = vim.tbl_extend('force', k.opts or {}, { buffer = buffer, desc = k.desc, silent = true })

    if has and cond then
      vim.keymap.set(k.mode or 'n', k[1], k[2], otps)
    end
  end
end

M._supports_method = {}

function M.setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    ---@diagnostic disable-next-line: no-unknown
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

function M._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end

  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

M.get_raw_config = function(server)
  local ok, ret = pcall(require, "lspconfig.configs." .. server)
  if ok then
    return ret
  end
  return require("lspconfig.server_configurations." .. server)
end

return M
