local opt = vim.opt

vim.g.mapleader = " "

-- editing & formatting
opt.autoindent = true
opt.completeopt = "menu,menuone,noselect,popup"
opt.conceallevel = 2
opt.copyindent = true
opt.expandtab = true
opt.formatexpr = "v:lua.require('yuki').format.formatexpr()"
opt.preserveindent = true
opt.shiftround = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.virtualedit = "block"

-- display & appearance
opt.cursorcolumn = false
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false
opt.smoothscroll = true
opt.wildmode = "longest:full,full"
opt.winborder = "rounded"
opt.winminwidth = 5
opt.wrap = false

-- files, buffers & backup
opt.autochdir = false
opt.autoread = true
opt.autowrite = true
opt.fileencoding = "utf-8"
opt.undofile = true
opt.undolevels = 1000
opt.swapfile = false

-- search & patterns
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true
opt.wrapscan = true

-- windows splitting
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true

-- folding
opt.foldexpr = "v:lua.require'yuki'.treesitter.foldexpr()"
opt.foldmarker = "#region,#endregion"
opt.foldmethod = "expr"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldtext = ""

-- system & misc
opt.clipboard = "unnamedplus"
opt.encoding = "utf-8"
opt.history = 1000
opt.mouse = "a"
opt.timeoutlen = 300
opt.updatetime = 200

-- Fill characters
opt.fillchars = {
  diff = "╱",
  eob = " ",
  fold = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
}

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
