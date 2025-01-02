-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_picker = "telescope"

local opts = vim.opt

opts.swapfile = false

-- Set filetypes for different extensions
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  extension = {
    mdx = "markdown",
    conf = "bash",
  },
})
