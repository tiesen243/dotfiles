require("yuki").setup({
  plugins = {
    "plugins.coding",
    "plugins.editor",
    "plugins.lsp",
    "plugins.ui",

    "plugins.langs.lua",

    "plugins.langs.c",
    "plugins.langs.dot",
    "plugins.langs.json",
    "plugins.langs.markdown",

    "plugins.langs.tailwind",
    "plugins.langs.typescript",

    "plugins.langs.python",

    "plugins.extras.ai",
    "plugins.extras.oxc",
  },
})

vim.cmd.colorscheme("vercel")
