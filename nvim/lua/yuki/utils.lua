local M = {}

---@param name string
M.create_augroup = function(name)
  return vim.api.nvim_create_augroup("yuki_" .. name, { clear = true })
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

---@param key string
---@param lhs string | function
---@param desc string
---@param opts table | nil
M.map = function(key, lhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, noremap = true, silent = true }, opts or {})
  local mode = opts.mode or "n"
  opts.mode = nil

  local ft = opts.ft or nil
  opts.ft = nil

  if ft then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function(ev)
        vim.keymap.set(
          mode,
          key,
          lhs,
          vim.tbl_extend("force", opts, {
            buffer = ev.buf,
          })
        )
      end,
    })
  else
    vim.keymap.set(mode, key, lhs, opts)
  end
end

---@param a table
---@param b table
M.merge = function(a, b)
  if type(a) ~= "table" then
    return b
  end
  if type(b) ~= "table" then
    return b
  end

  local result = vim.deepcopy(a)

  for k, v in pairs(b) do
    if type(v) == "table" and type(result[k]) == "table" then
      if vim.islist(v) and vim.islist(result[k]) then
        vim.list_extend(result[k], v) -- 👈 append
      else
        result[k] = M.merge(result[k], v)
      end
    else
      result[k] = v
    end
  end

  return result
end

return M
