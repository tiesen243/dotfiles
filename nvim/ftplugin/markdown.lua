-- Markdown specific settings
vim.b.wrap = true        -- Wrap text
vim.b.breakindent = true -- Match indent on line break
vim.b.linebreak = true   -- Line break on whole words

-- Allow j/k when navigating wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Spell check
vim.b.spelllang = "en_us"
vim.b.spell = true
