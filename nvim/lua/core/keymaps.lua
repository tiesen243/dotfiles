local map = vim.keymap.set

local opts = function(desc)
  return { noremap = true, silent = true, expr = false, nowait = false, desc = desc }
end

map("n", "<C-a>", "<cmd>normal! ggVG<cr>", opts("Select all"))

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts("Quit search mode"))

map("n", "<leader>q", "<cmd>wqa<cr>", opts("Save and close all buffers"))
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>write<cr><esc>", opts("Save current buffer"))

-- Do things without affecting the registers
map({ "v", "n" }, "x", '"_x', opts("Delete without yanking"))

-- Undo & Redo
map("n", "u", "<nop>", opts("Disable undo"))
map("n", "<C-z>", "<cmd>undo<cr>", opts("Undo"))
map("n", "<C-r>", "<cmd>redo<cr>", opts("Redo"))

-- Increment & Decrement
map("n", "+", "<C-a>", opts("Increment"))
map("n", "-", "<C-x>", opts("Decrement"))

-- Split navigation
map("n", "<leader>s", "<nop>", opts("Split"))
map("n", "<leader>sv", "<cmd>vsplit<cr>", opts("Split vertically"))
map("n", "<leader>ss", "<cmd>split<cr>", opts("Split horizontally"))

-- Move Lines
map("n", "<A-k>", "<cmd>m .-2<cr>==", opts("Move Up"))
map("n", "<A-j>", "<cmd>m .+1<cr>==", opts("Move Down"))
map("v", "<A-k>", ":m '<-2<cr>gv=gv", opts("Move Up"))
map("v", "<A-j>", ":m '>+1<cr>gv=gv", opts("Move Down"))

-- Indentation
map("n", "<", "<<", opts("Indent"))
map("n", ">", ">>", opts("Indent"))
map("v", "<", "<gv", opts("Indent"))
map("v", ">", ">gv", opts("Indent"))

-- Terminal
map("t", "<esc>", "<C-\\><C-n>", opts("Exit terminal mode"))

-- Options
map("n", "<leader>o", "<nop>", opts("Options"))
map("n", "<leader>ol", "<cmd>Lazy<cr>", opts("Lazy"))
map("n", "<leader>om", "<cmd>Mason<cr>", opts("Mason"))
map("n", "<leader>ow", "<cmd>set wrap!<cr>", opts("Toggle wrap text"))
map("n", "<leader>os", "<cmd>set spell!<cr>", opts("Toggle spell check"))
map("n", "<leader>on", "<cmd>set number!<cr>", opts("Toggle line number"))
map("n", "<leader>oc", "<cmd>Telescope colorscheme<cr>", opts("Colorscheme"))
map("n", "<leader>ot", "<cmd>TransparentToggle<cr>", opts("Toogle transparent"))
