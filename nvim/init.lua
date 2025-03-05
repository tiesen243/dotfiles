-- Speed up loading Lua modules in Neovim
if vim.loader then
  vim.loader.enable()
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

_G.Yuki = require("utils")
Yuki.configs = {
  auto_format = true,
  logo = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
 ╚████╔╝ ██║   ██║█████╔╝ ██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║
   ██║   ╚██████╔╝██║  ██╗██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
   ]],
  icons = require("utils.icons"),
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.ai.copilot" },

    -- add supported langues
    -- you can add more via https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras/lang
    { import = "plugins.lang.c" },
    { import = "plugins.lang.dot" },
    { import = "plugins.lang.git" },
    { import = "plugins.lang.java" },
    { import = "plugins.lang.json" },
    { import = "plugins.lang.markdown" },
    { import = "plugins.lang.prisma" },
    { import = "plugins.lang.tailwind" },
    { import = "plugins.lang.typescript" },
  },
  install = { colorscheme = { "carbonfox" } },
  checker = { enabled = false },
})

require("core.autocmds")
require("core.keymaps")
require("core.options")

Yuki.format.setup()
