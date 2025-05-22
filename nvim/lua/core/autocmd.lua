vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if we need to reload the file when it changed",
  group = Yuki.utils.create_augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = Yuki.utils.create_augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  desc = "Resize splits if window got resized",
  group = Yuki.utils.create_augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Go to last loc when opening a buffer",
  group = Yuki.utils.create_augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close some filetypes with <q>",
  group = Yuki.utils.create_augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Make it easier to close man-files when opened inline",
  group = Yuki.utils.create_augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Wrap and check for spell in text filetypes",
  group = Yuki.utils.create_augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Fix conceallevel for json files",
  group = Yuki.utils.create_augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable line numbers in CopilotChat",
  group = Yuki.utils.create_augroup("copilot_chat"),
  pattern = "copilot-*",
  callback = function()
    -- Set buffer-local options
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
  group = Yuki.utils.create_augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    ---@diagnostic disable-next-line: undefined-field
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
