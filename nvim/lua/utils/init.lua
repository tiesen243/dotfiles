local M = {}

M.actions = require("utils.actions")
M.cmp = require("utils.cmp")
M.format = require("utils.format")
M.lsp = require("utils.lsp")
M.ui = require("utils.ui")

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

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
M.memoize = function(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

M.get_pkg_path = function(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    Snacks.notify.warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path),
      { title = "LSP" }
    )
  end
  return ret
end

return M
