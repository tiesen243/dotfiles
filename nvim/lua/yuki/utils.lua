local M = {}

M.has = function(name)
  return require("lazy.core.config").spec.plugins[name] ~= nil
end

---@param direction string | 'h' | 'j' | 'k' | 'l'
M.navigate = function(direction)
  local mappings = { h = "left", j = "bottom", k = "top", l = "right" }
  local left_win = vim.fn.winnr("1" .. direction)
  if vim.fn.winnr() ~= left_win then
    vim.api.nvim_command("wincmd " .. direction)
  else
    local command = "kitty @ kitten navigate_kitty.py " .. mappings[direction]
    vim.fn.system(command)
  end
end

---@param char string
M.toggle_eol = function(char)
  local line = vim.api.nvim_get_current_line()
  if line:sub(-1) == char then
    vim.api.nvim_set_current_line(line:sub(1, -2))
  else
    vim.api.nvim_set_current_line(line .. char)
  end
end

M.create_augroup = function(name)
  return vim.api.nvim_create_augroup("yuki_" .. name, { clear = true })
end

M.foldexpr = function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    -- as long as we don't have a filetype, don't bother
    -- checking if treesitter is available (it won't)
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    if vim.bo[buf].filetype:find("dashboard") then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

M.get_time = function()
  return " " .. os.date("%R")
end

return M
