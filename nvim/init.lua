-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

_G.Yuki = require("yuki")
Yuki.merge_config({
  colorscheme = "vercel",
  transparentEnable = true,
  logo = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗██╗   ██╗██╗███╗   ███╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║██║   ██║██║████╗ ████║
 ╚████╔╝ ██║   ██║█████╔╝ ██║██║   ██║██║██╔████╔██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║   ╚██████╔╝██║  ██╗██║ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
   ]],
})

Yuki.setup({
  spec = {
    { import = "plugins" },

    { import = "plugins.lang.dot" },
    { import = "plugins.lang.json" },
    { import = "plugins.lang.lua" },
    { import = "plugins.lang.markdown" },
    { import = "plugins.lang.tailwind" },
    { import = "plugins.lang.typescript" },

    { import = "plugins.extras.ai" },
    { import = "plugins.extras.oxc" },
  },
  install = { colorschema = Yuki.configs.colorscheme },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
