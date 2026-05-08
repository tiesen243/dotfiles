require("yuki").setup({
  theme = "vercel",

  plugins = {
    "plugins.coding",
    "plugins.editor",
    "plugins.lsp",
    "plugins.ui",

    "plugins.langs.json",
    "plugins.langs.lua",
    "plugins.langs.markdown",

    "plugins.langs.tailwind",
    "plugins.langs.typescript",

    "plugins.langs.python",

    "plugins.extras.ai",
    "plugins.extras.oxc",
  },
})
