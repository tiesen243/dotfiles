---@param key string
---@param lhs string|function
---@param opts table?
---@param mode string|string[]?
local map = function(key, lhs, opts, mode)
  mode = mode or "n"
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.keymap.set(mode, key, lhs, opts)
end

-- general
map("<leader>qq", "<cmd>quit<cr>", { desc = "Quit" })
map("<leader>qa", "<cmd>quitall<cr>", { desc = "Quit All" })
map("<leader>qs", "<cmd>wqall<cr>", { desc = "Save & Quit All" })
map("<C-s>", "<cmd>write<cr><esc>", { desc = "Save File" }, { "n", "i", "v" })
map("p", [["_dP]], { desc = "Paste without yank" }, "x")
map("<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" }, { "i", "n", "s" })

-- toggle eol
-- stylua: ignore start
map(",", function() Yuki.utils.toggle_eol(",") end, { desc = "Toggle ," })
map(";", function() Yuki.utils.toggle_eol(";") end, { desc = "Toggle ;" })
map("<C-'>", function() Yuki.utils.toggle_eol("'") end, { desc = "Toggle '" })
-- stylua: ignore end

-- better up/down
map("j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }, { "n", "x" })
map("<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }, { "n", "x" })
map("k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }, { "n", "x" })
map("<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }, { "n", "x" })

-- move to window using the <ctrl> hjkl keys
if vim.fn.executable("kitty") == 1 then
	-- stylua: ignore start
	map("<C-h>", function() Yuki.utils.navigate("h") end, { desc = "Go to Left Window", silent = true },{ "n", "v" })
	map( "<C-j>", function() Yuki.utils.navigate("j") end, { desc = "Go to Lower Window", silent = true },{ "n", "v" })
	map( "<C-k>", function() Yuki.utils.navigate("k") end, { desc = "Go to Upper Window", silent = true },{ "n", "v" })
	map( "<C-l>", function() Yuki.utils.navigate("l") end, { desc = "Go to Right Window", silent = true },{ "n", "v" })
  -- stylua: ignore end
else
  map("<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true }, { "n", "v" })
  map("<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true }, { "n", "v" })
  map("<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true }, { "n", "v" })
  map("<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true }, { "n", "v" })
end

-- move lines
map("<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" }, "i")
map("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" }, "i")
map("<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" }, "v")
map("<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" }, "v")

-- add undo break-points
map(",", ",<c-g>u", {}, "i")
map(".", ".<c-g>u", {}, "i")
map(";", ";<c-g>u", {}, "i")

-- better indenting
map("<", "<<")
map(">", ">>")
map("<", "<gv", {}, "v")
map(">", ">gv", {}, "v")

-- buffers
-- stylua: ignore start
map("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
-- stylua: ignore end

-- diagnostic
local diagnostic_goto = function(next, severity)
  ---@diagnostic disable-next-line: deprecated
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }, "x")
map("n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }, "o")
map("N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }, "x")
map("N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }, "o")

-- highlights under cursor
map("<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- snacks toggle
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
  :map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- quickfix / location list
map("<leader>xf", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle Quickfix" })
map("<leader>xl", function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd("lclose")
  else
    vim.cmd("lopen")
  end
end, { desc = "Toggle Location List" })

-- stylua: ignore start
if vim.fn.executable("lazygit") == 1 then
  ---@diagnostic disable-next-line: missing-fields
  map( "<leader>gg", function() Snacks.lazygit({ cwd = Snacks.git.get_root() }) end, { desc = "Lazygit (Root Dir)" })
  map("<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end
-- stylua: ignore end

-- Terminal Mappings
map("<c-/>", function()
  Snacks.terminal(nil, { cwd = Snacks.git.get_root() })
end, { desc = "Terminal (Root Dir)" })
map("<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" }, "t")
