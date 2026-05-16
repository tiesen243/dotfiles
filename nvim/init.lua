require("yuki").setup({
  theme = "vercel",
  config = {
    ai_cmp = false,
  },

  plugins = {
    "plugins.coding",
    "plugins.editor",
    "plugins.mason",
    "plugins.ui",

    "plugins.langs.json",
    "plugins.langs.lua",
    "plugins.langs.markdown",

    "plugins.langs.tailwind",
    "plugins.langs.typescript",

    "plugins.langs.python",
    "plugins.langs.rust",

    "plugins.extras.ai",
    "plugins.extras.oxc",
  },
})
