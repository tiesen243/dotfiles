require("vim._core.ui2").enable({})

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

    "plugins.langs.c",

    "plugins.langs.tailwind",
    "plugins.langs.typescript",

    "plugins.extras.ai",
    "plugins.extras.oxc",
  },
})
