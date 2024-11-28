local opt = vim.opt

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- General
opt.syntax = "on"
opt.foldlevel = 99
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions

-- Tab and shift
opt.tabstop = 2 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent

-- Disable swapfile
opt.swapfile = false

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set filetypes for different extensions
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  extension = {
    mdx = "markdown",
    conf = "bash",
  },
})
