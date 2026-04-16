local M = {}

_G.Yuki = {}

M.setup = function(opts)
  Yuki.configs = require("yuki.configs")
  Yuki.cmp = require("yuki.cmp")
  Yuki.format = require("yuki.format")
  Yuki.treesitter = require("yuki.treesitter")
  Yuki.utils = require("yuki.utils")

  require("core.options")
  require("core.autocmds")
  require("core.keymaps")

  require("yuki.plugin").load(opts.plugins)

  vim.api.nvim_create_user_command("YukiPlugins", function()
    require("yuki.plugin").open()
  end, {})

  Yuki.format.setup()
end

return M
