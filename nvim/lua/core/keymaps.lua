local map = vim.keymap.set

-- general
map("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "Quit All" })
map("n", "<leader>qs", "<cmd>wqall<cr>", { desc = "Save & Quit All" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Save File" })
map("x", "p", [["_dP]], { desc = "Paste without yank" })
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
if vim.fn.executable("kitty") == 1 then
	-- stylua: ignore start
	map({ "n", "v" }, "<C-h>", function() Yuki.utils.navigate("h") end, { desc = "Go to Left Window", silent = true })
	map({ "n", "v" }, "<C-j>", function() Yuki.utils.navigate("j") end, { desc = "Go to Lower Window", silent = true })
	map({ "n", "v" }, "<C-k>", function() Yuki.utils.navigate("k") end, { desc = "Go to Upper Window", silent = true })
	map({ "n", "v" }, "<C-l>", function() Yuki.utils.navigate("l") end, { desc = "Go to Right Window", silent = true })
  -- stylua: ignore end
else
  map({ "n", "v" }, "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
  map({ "n", "v" }, "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
  map({ "n", "v" }, "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
  map({ "n", "v" }, "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
end

-- move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("n", "<", "<<")
map("n", ">", ">>")
map("v", "<", "<gv")
map("v", ">", ">gv")

-- buffers
-- stylua: ignore start
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
-- stylua: ignore end

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- stylua: ignore start
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit({ cwd = Snacks.git.get_root() }) end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end

-- floating terminal
map("n", "<c-/>", function() Snacks.terminal(nil, { cwd = Snacks.git.get_root() }) end, { desc = "Terminal (Root Dir)" })
map("n", "<c-_>", function() Snacks.terminal(nil, { cwd = Snacks.git.get_root() }) end, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
-- stylua: ignore end
