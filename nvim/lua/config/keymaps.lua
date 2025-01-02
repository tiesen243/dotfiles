-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map({ "n", "x" }, "<C-a>", "gg<S-v>G", { desc = "Select all" })
map({ "i", "x", "n", "s" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
map("n", "u", "<nop>")

map("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>quitall<cr>", { desc = "Quit all" })
map("n", "<leader>qs", "<cmd>wqa<cr>", { desc = "Quit and save" })
