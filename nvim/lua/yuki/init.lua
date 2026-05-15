local M = {}

_G.Yuki = {}

---@class YukiConfig
---@field ai_cmp boolean|nil
---@field icons table|nil
---@field nesting_rules table|nil
---@field logo string|nil

---@class YukiOptions
---@field theme string|nil
---@field config YukiConfig|nil
---@field plugins table

---@param opts YukiOptions
M.setup = function(opts)
  Yuki.configs = require("yuki.configs")
  Yuki.configs = vim.tbl_deep_extend("force", Yuki.configs, opts.config or {})

  Yuki.cmp = require("yuki.cmp")
  Yuki.format = require("yuki.format")
  Yuki.treesitter = require("yuki.treesitter")
  Yuki.utils = require("yuki.utils")

  require("core.options")
  require("core.autocmds")
  require("core.keymaps")

  require("yuki.plugin").setup(opts.plugins)
  require("yuki.lsp").setup()
  Yuki.format.setup()

  vim.cmd.colorscheme(opts.theme or "habamax")
end

return M
