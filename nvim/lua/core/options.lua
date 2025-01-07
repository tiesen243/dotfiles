local opt = vim.opt

-- Tab / Indentation
opt.tabstop = 2 -- Number of spaces tabs count for
opt.shiftwidth = 2 -- Size of an indent
opt.softtabstop = 2 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically
opt.wrap = false -- Disable line wrap

-- Search
opt.incsearch = true -- Show search matches as you type
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.hlsearch = true -- Highlighting search results

-- Apperances
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.termguicolors = true -- True color support
opt.colorcolumn = "100" -- Highlight column 100
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.cmdheight = 1 -- Height of the command bar
opt.scrolloff = 4 -- Lines of context
opt.completeopt = "menu,menuone,noselect"

-- Behaviour
opt.hidden = true -- Enable background buffers
opt.errorbells = false -- Disable error bells
opt.swapfile = false -- Disable swap files
opt.backup = false -- Disable backup files
opt.undodir = vim.fn.expand("~/.cache/nvim/undo") -- Set undo directory
opt.backspace = "indent,eol,start" -- Allow backspacing over everything in insert mode
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen" -- Keep windows open
opt.splitright = true -- Put new windows right of current
opt.autochdir = true -- Change directory to the file being edited
opt.autoindent = true -- Enable auto indent
opt.autowrite = true -- Enable auto write
opt.autoread = true -- Enable auto read
opt.iskeyword:append({ "-" }) -- Treat dash specially when moving words
opt.mouse = "a" -- Enable mouse mode
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.modifiable = true -- Enable modifiable
opt.encoding = "utf-8" -- Set encoding

-- Others
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m" -- Format for grepping
opt.grepprg = "rg --vimgrep" -- Use ripgrep for grepping
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view" -- Jump to the first match
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.pumblend = 0 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.ruler = false -- Disable the default ruler
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.spelllang = { "en" } -- Enable spell checking
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000 -- Maximum number of changes that can be undone
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.vim.treesitter.foldexpr()"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.cmd("colorscheme " .. Yuki.colorcheme)
