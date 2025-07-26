local M = {}

M.utils = require("yuki.utils")
M.format = require("yuki.format")

M.configs = {
  icons = require("yuki.icons"),
}

---@param options {colorscheme: string, logo: string}
M.merge_config = function(options)
  M.configs = vim.tbl_deep_extend("force", M.configs, options or {})
end

M.setup = function()
  -- Load core configuration modules
  require("core.autocmd")
  require("core.keymaps")
  require("core.options")

  -- Apply colorscheme
  vim.cmd.colorscheme(M.configs.colorscheme)

  -- Initialize formatting
  M.format.setup()
end

return M
