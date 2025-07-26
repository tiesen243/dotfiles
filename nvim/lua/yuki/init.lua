local M = {}

M.utils = require("yuki.utils")
M.format = require("yuki.format")

M.configs = {}
M.configs.icons = require("yuki.icons")

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
