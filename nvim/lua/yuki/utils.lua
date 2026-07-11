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

--- @param root_files string[] List of root-marker files to append to.
--- @param new_names string[] Potential root-marker filenames (e.g. `{ 'package.json', 'package.json5' }`) to inspect for the given `field`.
--- @param field string Field to search for in the given `new_names` files.
--- @param fname string Full path of the current buffer name to start searching upwards from.
function M.root_markers_with_field(root_files, new_names, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local found = vim.fs.find(new_names, { path = path, upward = true, type = "file" })

  for _, f in ipairs(found or {}) do
    -- Match the given `field`.
    local file = assert(io.open(f, "r"))
    for line in file:lines() do
      if line:find(field) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
    file:close()
  end

  return root_files
end

function M.insert_package_json(root_files, field, fname)
  return M.root_markers_with_field(root_files, { "package.json", "package.json5" }, field, fname)
end

function M.get_time()
  return os.date("%H:%M")
end

return M
