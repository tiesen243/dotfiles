-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.title = true
vim.opt.shell = "zsh"
vim.opt.number = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true

vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.scrolloff = 10
vim.opt.expandtab = true
vim.opt.inccommand = "split"
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })

-- Window splits
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"

-- Auto
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.autochdir = true
vim.opt.autowriteall = true

-- Mouse
vim.opt.mouse = ""

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Cursor
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
	vim.opt.cmdheight = 0
end
