local M = {}

M.cmp = require("yuki.cmp")
M.utils = require("yuki.utils")
M.format = require("yuki.format")
M.treesitter = require("yuki.treesitter")

M.configs = {
  colorscheme = "default",
  transparentEnable = false,
  icons = require("yuki.icons"),
  nesting_rules = require("yuki.nesting_rules"),
}

---@param options {colorscheme: string, transparentEnable: boolean, logo: string}
M.merge_config = function(options)
  M.configs = vim.tbl_deep_extend("force", M.configs, options or {})
end

--- @param lazyOpts table|nil
M.setup = function(lazyOpts)
  -- Load configuration
  require("core.options")
  require("lazy").setup(lazyOpts or {})

  -- Load autocmd and keymaps
  require("core.autocmd")
  require("core.keymaps")

  -- Apply colorscheme
  vim.cmd.colorscheme(M.configs.colorscheme)

  -- Initialize formatting
  M.format.setup()
end

return M
