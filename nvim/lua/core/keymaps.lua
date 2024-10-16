local bind = vim.keymap.set

local opts = function(desc)
	return { noremap = true, silent = true, expr = false, nowait = false, desc = desc }
end

-- General
bind("n", "<C-a>", "<cmd>normal! ggVG<cr>", opts("Select all"))
bind({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts("Quit search mode"))
bind("n", "<leader>q", "<cmd>wqa<cr>", opts("Save and close all buffers"))
bind({ "i", "x", "n", "s" }, "<C-s>", "<cmd>write<cr><esc>", opts("Save current buffer"))

-- Do things without affecting the registers
bind({ "v", "n" }, "x", '"_x', opts("Delete without yanking"))
bind({ "x", "n", "s" }, "p", "pgvy", opts("Paste without yanking"))

-- Undo & Redo
bind("n", "u", "<nop>", opts("Disable undo"))
bind({ "n", "i" }, "<C-r>", "<cmd>redo<cr>", opts("Redo"))
bind({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", opts("Undo"))

-- Increment & Decrement
bind("n", "+", "<C-a>", opts("Increment current number"))
bind("n", "-", "<C-x>", opts("Decrement current number"))

-- Move Lines
bind("n", "<A-k>", "<cmd>m .-2<cr>==", opts("Move Up"))
bind("n", "<A-j>", "<cmd>m .+1<cr>==", opts("Move Down"))
bind("v", "<A-k>", ":m '<-2<cr>gv=gv", opts("Move Up"))
bind("v", "<A-j>", ":m '>+1<cr>gv=gv", opts("Move Down"))

-- Indentation
bind("n", "<", "<<", opts("Indent left"))
bind("n", ">", ">>", opts("Indent right"))
bind("v", "<", "<gv", opts("Indent left"))
bind("v", ">", ">gv", opts("Indent right"))

-- Terminal
bind("t", "<esc>", "<C-\\><C-n>", opts("Exit terminal mode"))

-- Options
bind("n", "<leader>ol", "<cmd>Lazy<cr>", opts("Lazy"))
bind("n", "<leader>om", "<cmd>Mason<cr>", opts("Mason"))
bind("n", "<leader>ow", "<cmd>set wrap!<cr>", opts("Toggle wrap text"))
bind("n", "<leader>os", "<cmd>set spell!<cr>", opts("Toggle spell check"))
bind("n", "<leader>on", "<cmd>set number!<cr>", opts("Toggle line number"))
bind("n", "<leader>oc", "<cmd>Telescope colorscheme<cr>", opts("Colorscheme"))
bind("n", "<leader>ot", "<cmd>TransparentToggle<cr>", opts("Toogle transparent"))
