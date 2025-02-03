local M = {}

---@param t table
---@param key string
---@param values table
M.extend = function(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

---@param method string|string[]
M.has = function(buffer, method)
  if type(method) == 'table' then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find '/' and method or 'textDocument/' .. method
  local clients = vim.lsp.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@param client table
---@param bufnr vbuf
M.lsp_attach = function(client, bufnr)
  local builtin = require 'telescope.builtin'
  -- stylua: ignore start
  local keys = {
    { 'gd',         builtin.lsp_definitions,               desc = '[G]oto [D]efinition',       has = 'definition' },
    { 'gD',         vim.lsp.buf.declaration,               desc = '[G]oto [D]eclaration' },
    { 'gr',         builtin.lsp_references,                desc = '[G]oto [R]eferences',       opts = { nowait = true } },
    { 'gi',         builtin.lsp_implementations,           desc = '[G]oto [I]mplementation' },
    { '<C-j>',      vim.lsp.buf.signature_help,            desc = 'Signature help',            has = 'signatureHelp',                                            mode = { 'i' } },
    { 'J',          vim.lsp.buf.signature_help,            desc = 'Signature help',            has = 'signatureHelp' },
    { '<C-k>',      vim.lsp.buf.hover,                     desc = '[H]over doc',               mode = { 'i' } },
    { 'K',          vim.lsp.buf.hover,                     desc = 'Hover doc',                 has = 'hover', },
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
  Snacks.toggle({
    name = "Format on save",
    get = function() return Yuki.coding.format_on_save end,
    set = function(state) Yuki.coding.format_on_save = state end,
  }):map("<leader>cF")
  -- stylua: ignore end

  for _, k in ipairs(keys) do
    local has = not k.has or M.has(bufnr, k.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == 'function') and not keys.cond()))
    local otps = vim.tbl_extend('force', k.opts or {}, { buffer = bufnr, desc = k.desc, silent = true })

    if has and cond then
      vim.keymap.set(k.mode or 'n', k[1], k[2], otps)
    end
  end

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end
end

---@param direction string | 'h' | 'j' | 'k' | 'l'
M.navigate = function(direction)
  local mappings = { h = 'left', j = 'bottom', k = 'top', l = 'right' }
  local left_win = vim.fn.winnr('1' .. direction)
  if vim.fn.winnr() ~= left_win then
    vim.api.nvim_command('wincmd ' .. direction)
  else
    local command = 'kitty @ kitten navigate_kitty.py ' .. mappings[direction]
    vim.fn.system(command)
  end
end

M.get_battery_state = function()
  local capacity = io.open('/sys/class/power_supply/BAT1/capacity', 'r')
  local status = io.open('/sys/class/power_supply/BAT1/status', 'r')

  if capacity == nil or status == nil then
    return
  end

  local capacity_value = tonumber(capacity:read '*all')
  local status_value = status:read '*all'
  local icon = '󰁻'

  if status_value:match 'Charging' then
    icon = '󰂅'
  elseif capacity_value == 100 then
    icon = '󰁹'
  elseif capacity_value >= 80 then
    icon = '󰂁'
  elseif capacity_value >= 60 then
    icon = '󰁿'
  elseif capacity_value >= 40 then
    icon = '󰁾'
  elseif capacity_value >= 20 then
    icon = '󰁽'
  else
    icon = '󰁻'
  end

  capacity:close()
  status:close()

  return icon .. ' ' .. tostring(capacity_value)
end

M.get_time = function()
  return ' ' .. os.date '%R'
end

return M
