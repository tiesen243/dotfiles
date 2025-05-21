local M = {}

---@class YukiFormatter
---@field name string
---@field priority number
---@field active fun(bufnr: number): boolean
---@field command fun(bufnr: number)

---@type YukiFormatter[]
M.formatter = {}

---@param formatter YukiFormatter
M.register = function(formatter)
  table.insert(M.formatter, formatter)
  table.sort(M.formatter, function(a, b)
    return a.priority < b.priority
  end)
end

M.formatexpr = function()
  if Yuki.utils.has("conform.nvim") then
    return require("conform").formatexpr()
  else
    return vim.lsp.formatexpr({ timeout_ms = 3000 })
  end
end

---@param opts? { buf?: number }
M.format = function(opts)
  opts = opts or {}
  local bufnr = opts.buf or vim.api.nvim_get_current_buf()
  local have = false

  for _, formatter in ipairs(M.formatter) do
    if formatter.active(bufnr) then
      have = true
      local ok, err = pcall(formatter.command, bufnr)
      if not ok then
        vim.notify("Formatter " .. formatter.name .. " failed: " .. err, vim.log.levels.ERROR)
      end
    end
  end

  if not have then
    vim.notify("No formatters available for this buffer.", vim.log.levels.WARN)
  end
end

---@param buf? number
function M.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  if baf ~= nil then
    return baf
  end

  return gaf == nil or gaf
end

---@param buf? number
M.info = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = M.enabled(buf)

  local lines = {
    "# Status",
    ("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
    ("- [%s] buffer **%s**"):format(
      enabled and "x" or " ",
      baf == nil and "inherit" or baf and "enabled" or "disabled"
    ),
    "# Formatters",
  }

  for _, formatter in ipairs(M.formatter) do
    local is_active = false
    if type(formatter.active) == "function" then
      is_active = formatter.active(buf)
    else
      ---@diagnostic disable-next-line: cast-local-type
      is_active = formatter.active
    end

    lines[#lines + 1] = ("- [%s] %s"):format(is_active and "x" or " ", formatter.name)
  end

  vim.notify(
    table.concat(lines, "\n"),
    vim.log.levels.INFO,
    { title = "YukiFormat (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

M.setup = function()
  vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format on save",
    group = Yuki.utils.create_augroup("format_on_save"),
    callback = function(event)
      if not M.enabled(event.buf) then
        return
      end
      M.format({ buf = event.buf })
    end,
  })

  vim.api.nvim_create_user_command("YukiFormat", function()
    M.format()
  end, { desc = "Format current buffer" })

  vim.api.nvim_create_user_command("YukiFormatInfo", function()
    M.info()
  end, { desc = "Show formatters info" })
end

return M
