Yuki.utils.map("<C-s>", "<esc><cmd>write<cr>", "Saved", { mode = { "n", "i", "v" } })

Yuki.utils.map("<leader>qq", "<cmd>quit<cr>", "Quit")
Yuki.utils.map("<leader>qa", "<cmd>quitall<cr>", "Quit All")
Yuki.utils.map("<leader>qs", "<cmnd>wq<cr>", "Save & Quit")
Yuki.utils.map("<leader>qA", "<cmnd>wqall<cr>", "Save & Quit All")

Yuki.utils.map("p", [["_dP]], "Paste without yank", { mode = "x" })

Yuki.utils.map("<Esc>", "<C-\\><C-N>", "Exit terminal mode", { mode = "t" })

Yuki.utils.map("<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, "Escape and Clear hlsearch", { mode = { "i", "n", "s" }, expr = true })
Yuki.utils.map(
  "<leader>h",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  "Search and Replace",
  { mode = "n" }
)

-- better up/down
Yuki.utils.map("j", "v:count == 0 ? 'gj' : 'j'", "Down", { mode = { "n", "x" }, expr = true })
Yuki.utils.map("<Down>", "v:count == 0 ? 'gj' : 'j'", "Down", { mode = { "n", "x" }, expr = true })
Yuki.utils.map("k", "v:count == 0 ? 'gk' : 'k'", "Up", { mode = { "n", "x" }, expr = true })
Yuki.utils.map("<Up>", "v:count == 0 ? 'gk' : 'k'", "Up", { mode = { "n", "x" }, expr = true })
Yuki.utils.map("<C-d>", "<C-d>zz", "Scroll Down")

-- move to window using the <ctrl> hjkl keys
if vim.fn.executable("kitty") == 1 then
	-- stylua: ignore start
	Yuki.utils.map("<C-h>", function() Yuki.utils.navigate("h") end, "Go to Left Window", { mode = { "n", "v" } })
	Yuki.utils.map( "<C-j>", function() Yuki.utils.navigate("j") end, "Go to Lower Window", { mode = { "n", "v" } })
	Yuki.utils.map( "<C-k>", function() Yuki.utils.navigate("k") end, "Go to Upper Window", { mode = { "n", "v" } })
	Yuki.utils.map( "<C-l>", function() Yuki.utils.navigate("l") end, "Go to Right Window", { mode = { "n", "v" } })
-- stylua: ignore end
else
  Yuki.utils.map("<C-h>", "<C-w>h", "Go to Left Window", { mode = { "n", "v" } })
  Yuki.utils.map("<C-j>", "<C-w>j", "Go to Lower Window", { mode = { "n", "v" } })
  Yuki.utils.map("<C-k>", "<C-w>k", "Go to Upper Window", { mode = { "n", "v" } })
  Yuki.utils.map("<C-l>", "<C-w>l", "Go to Right Window", { mode = { "n", "v" } })
end

-- move lines
Yuki.utils.map("<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", "Move Down")
Yuki.utils.map("<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", "Move Up")
Yuki.utils.map("<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move Down", { mode = "i" })
Yuki.utils.map("<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move Up", { mode = "i" })
Yuki.utils.map("<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", "Move Down", { mode = "v" })
Yuki.utils.map("<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Up", { mode = "v" })

-- add undo break-points
Yuki.utils.map(",", ",<c-g>u", "", { mode = "i" })
Yuki.utils.map(".", ".<c-g>u", "", { mode = "i" })
Yuki.utils.map(";", ";<c-g>u", "", { mode = "i" })

-- better indenting
Yuki.utils.map("<", "<<")
Yuki.utils.map(">", ">>")
Yuki.utils.map("<", "<gv", "", { mode = "v" })
Yuki.utils.map(">", ">gv", "", { mode = "v" })

-- toggle eol
-- stylua: ignore start
Yuki.utils.map(",", function() Yuki.utils.toggle_eol(",") end, "Toggle ," )
Yuki.utils.map(";", function() Yuki.utils.toggle_eol(";") end,  "Toggle ;" )
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
Yuki.utils.map("]d", diagnostic_goto(true), "Next Diagnostic")
Yuki.utils.map("[d", diagnostic_goto(false), "Prev Diagnostic")
Yuki.utils.map("]e", diagnostic_goto(true, "ERROR"), "Next Error")
Yuki.utils.map("[e", diagnostic_goto(false, "ERROR"), "Prev Error")
Yuki.utils.map("]w", diagnostic_goto(true, "WARN"), "Next Warning")
Yuki.utils.map("[w", diagnostic_goto(false, "WARN"), "Prev Warning")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
Yuki.utils.map("n", "'Nn'[v:searchforward].'zv'", "Next Search Result", { expr = true })
Yuki.utils.map("n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true, mode = "x" })
Yuki.utils.map("n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true, mode = "o" })
Yuki.utils.map("N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })
Yuki.utils.map("N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true, mode = "x" })
Yuki.utils.map("N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true, mode = "o" })

-- highlights under cursor
Yuki.utils.map("<leader>ui", vim.show_pos, "Inspect Pos")
Yuki.utils.map("<leader>uI", "<cmd>InspectTree<cr>", "Inspect Tree")
