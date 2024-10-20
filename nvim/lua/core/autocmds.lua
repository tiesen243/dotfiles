local function augroup(name)
	return vim.api.nvim_create_augroup("yuki_" .. name, { clear = true })
end

-- Highlight yanked text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Automatically format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("format_on_save"),
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("wrap_spell"),
	pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown", "mdx" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- map mdx to markdown filetype
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("mdx_to_markdown"),
	pattern = { "mdx" },
	callback = function(event)
		vim.bo[event.buf].filetype = "markdown"
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("close_with_q"),
	pattern = {
		"help",
		"lspinfo",
		"startuptime",
		"checkhealth",
		"gitsigns.blame",
		"rest_nvim_result",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
