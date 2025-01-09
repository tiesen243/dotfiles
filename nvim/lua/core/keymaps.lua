local map = vim.keymap.set

-- General
local opts = { noremap = true, silent = true }
map({ 'i', 'n' }, '<C-s>', '<cmd>w<cr><esc>', opts) -- Save with <C-s>
map({ 'n', 'x' }, '<C-a>', 'gg<S-v>G', opts)        -- Select all
map({ 'n', 'v' }, 'x', '"_x', opts)                 -- Delete without yanking
map('v', 'p', '"_dP', opts)                         -- Paste without yanking

map('n', '<leader>qq', '<cmd>quit<cr>', { desc = 'Quit', noremap = true, silent = true })
map('n', '<leader>qa', '<cmd>quitall<cr>', { desc = 'Quit All', noremap = true, silent = true })
map('n', '<leader>qs', '<cmd>wqall<cr>', { desc = 'Save and Quit', noremap = true, silent = true })

-- Better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys (interact with kitty terminal)
if vim.fn.executable 'kitty' == 1 then
  -- stylua: ignore start
  local utils = require('core.utils')
  map("n", "<C-h>", function() utils.navigate("h") end, { desc = "Go to Left Window", silent = true })
  map("n", "<C-j>", function() utils.navigate("j") end, { desc = "Go to Lower Window", silent = true })
  map("n", "<C-k>", function() utils.navigate("k") end, { desc = "Go to Upper Window", silent = true })
  map("n", "<C-l>", function() utils.navigate("l") end, { desc = "Go to Right Window", silent = true })
  -- stylua: ignore end
else
  map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', silent = true })
  map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', silent = true })
  map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', silent = true })
  map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', silent = true })
end

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Move Lines
map('n', 'J', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', 'K', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('v', 'J', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
map('v', 'K', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })


-- Buffers
-- stylua: ignore start
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to last buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
-- stylua: ignore end

-- Clear search and stop snippet on escape
map({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd 'noh'
  return '<esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- better indenting
map('n', '<', '<<')
map('n', '>', '>>')
map('v', '<', '<gv')
map('v', '>', '>gv')

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- windows
map('n', '<leader>w-', '<C-W>s', { desc = 'Split Window Below', remap = true })
map('n', '<leader>w\\', '<C-W>v', { desc = 'Split Window Right', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

-- stylua: ignore start

-- Git
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gl", function() Snacks.lazygit({ cwd = Snacks.git.get_root() }) end, { desc = "Lazy Git (rwd)" })
  map("n", "<leader>gL", function() Snacks.lazygit() end, { desc = "Lazy Git (cwd)" })
end
map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Blame Line" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end }) end,
  { desc = "Git Browse (copy)" })

-- UI
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.option("conceallevel",
  { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle({
  name = "Transparent Background",
  get = function() return vim.g.transparent_enabled end,
  set = function(state)
    if state then
      vim.cmd([[TransparentEnable]])
    else
      vim.cmd([[TransparentDisable]])
    end
  end,
}):map("<leader>ut")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.zoom():map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end
