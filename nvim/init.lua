require("yuki").setup({
  plugins = {
    "plugins.coding",
    "plugins.editor",
    "plugins.lsp",
    "plugins.ui",

    "plugins.langs.dot",
    "plugins.langs.json",
    "plugins.langs.lua",
    "plugins.langs.markdown",
    "plugins.langs.typescript",

    "plugins.extras.ai",
    "plugins.extras.oxc",
  },
})

vim.cmd.colorscheme("vercel")
