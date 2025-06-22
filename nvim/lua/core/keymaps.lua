---@param key string
---@param lhs string|function
---@param desc string?
---@param opts table?
local map = function(key, lhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, noremap = true, silent = true }, opts or {})
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.set(mode, key, lhs, opts)
end

-- general
map("<leader>qq", "<cmd>quit<cr>", "Quit")
map("<leader>qa", "<cmd>quitall<cr>", "Quit All")
map("<leader>qs", "<cmd>wqall<cr>", "Save & Quit All")
map("<C-s>", "<cmd>write<cr><esc>", "Save File", { mode = { "n", "i", "v" } })
map("p", [["_dP]], "Paste without yank", { mode = "x" })
map("<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, "Escape and Clear hlsearch", { mode = { "i", "n", "s" }, expr = true })
map("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Search and Replace", { mode = "n" })

-- toggle eol
-- stylua: ignore start
map(",", function() Yuki.utils.toggle_eol(",") end, "Toggle ," )
map(";", function() Yuki.utils.toggle_eol(";") end,  "Toggle ;" )
map("<C-'>", function() Yuki.utils.toggle_eol("'") end, "Toggle '" )
-- stylua: ignore end

-- better up/down
map("j", "v:count == 0 ? 'gj' : 'j'", "Down", { mode = { "n", "x" }, expr = true })
map("<Down>", "v:count == 0 ? 'gj' : 'j'", "Down", { mode = { "n", "x" }, expr = true })
map("k", "v:count == 0 ? 'gk' : 'k'", "Up", { mode = { "n", "x" }, expr = true })
map("<Up>", "v:count == 0 ? 'gk' : 'k'", "Up", { mode = { "n", "x" }, expr = true })

-- move to window using the <ctrl> hjkl keys
if vim.fn.executable("kitty") == 1 then
	-- stylua: ignore start
	map("<C-h>", function() Yuki.utils.navigate("h") end, "Go to Left Window", { mode = { "n", "v" } })
	map( "<C-j>", function() Yuki.utils.navigate("j") end, "Go to Lower Window", { mode = { "n", "v" } })
	map( "<C-k>", function() Yuki.utils.navigate("k") end, "Go to Upper Window", { mode = { "n", "v" } })
	map( "<C-l>", function() Yuki.utils.navigate("l") end, "Go to Right Window", { mode = { "n", "v" } })
  -- stylua: ignore end
else
  map("<C-h>", "<C-w>h", "Go to Left Window", { mode = { "n", "v" } })
  map("<C-j>", "<C-w>j", "Go to Lower Window", { mode = { "n", "v" } })
  map("<C-k>", "<C-w>k", "Go to Upper Window", { mode = { "n", "v" } })
  map("<C-l>", "<C-w>l", "Go to Right Window", { mode = { "n", "v" } })
end

-- move lines
map("<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", "Move Down")
map("<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", "Move Up")
map("<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move Down", { mode = "i" })
map("<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move Up", { mode = "i" })
map("<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", "Move Down", { mode = "v" })
map("<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Up", { mode = "v" })

-- add undo break-points
map(",", ",<c-g>u", "", { mode = "i" })
map(".", ".<c-g>u", "", { mode = "i" })
map(";", ";<c-g>u", "", { mode = "i" })

-- better indenting
map("<", "<<")
map(">", ">>")
map("<", "<gv", "", { mode = "v" })
map(">", ">gv", "", { mode = "v" })

-- buffers
-- stylua: ignore start
map("<leader>bb", "<cmd>e #<cr>",  "Switch to Other Buffer" )
map("<leader>bd", function() Snacks.bufdelete() end,  "Delete Buffer" )
map("<leader>bo", function() Snacks.bufdelete.other() end, "Delete Other Buffers" )
map("<leader>bD", "<cmd>:bd<cr>", "Delete Buffer and Window" )
-- stylua: ignore end

-- tabs
map("<leader>tn", "<cmd>tabnew<cr>", "New Tab")
map("<leader>tf", "<cmd>tabnew %<cr>", "New Tab with Current File")
map("<leader>tx", "<cmd>tabclose<cr>", "Close Tab")
map("<leader>to", "<cmd>tabonly<cr>", "Close Other Tabs")
map("[t", "<cmd>tabprevious<cr>", "Previous Tab")
map("]t", "<cmd>tabnext<cr>", "Next Tab")

-- diagnostic
local diagnostic_goto = function(next, severity)
  ---@diagnostic disable-next-line: deprecated
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("]d", diagnostic_goto(true), "Next Diagnostic")
map("[d", diagnostic_goto(false), "Prev Diagnostic")
map("]e", diagnostic_goto(true, "ERROR"), "Next Error")
map("[e", diagnostic_goto(false, "ERROR"), "Prev Error")
map("]w", diagnostic_goto(true, "WARN"), "Next Warning")
map("[w", diagnostic_goto(false, "WARN"), "Prev Warning")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "'Nn'[v:searchforward].'zv'", "Next Search Result", { expr = true })
map("n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true, mode = "x" })
map("n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true, mode = "o" })
map("N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })
map("N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true, mode = "x" })
map("N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true, mode = "o" })

-- highlights under cursor
map("<leader>ui", vim.show_pos, "Inspect Pos")
map("<leader>uI", "<cmd>InspectTree<cr>", "Inspect Tree")

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
end, "Toggle Quickfix")
map("<leader>xl", function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd("lclose")
  else
    vim.cmd("lopen")
  end
end, "Toggle Location List")

-- stylua: ignore start
if vim.fn.executable("lazygit") == 1 then
  ---@diagnostic disable-next-line: missing-fields
  map("<leader>gg", function() Snacks.lazygit({ cwd = Snacks.git.get_root() }) end, "Lazygit (Root Dir)")
  map("<leader>gG", function() Snacks.lazygit() end, "Lazygit (cwd)")
end
-- stylua: ignore end

-- Terminal Mappings
map("<c-/>", function()
  Snacks.terminal(nil, { cwd = Snacks.git.get_root() })
end, "Terminal (Root Dir)")
map("<C-/>", "<cmd>close<cr>", "Hide Terminal", { mode = "t" })
