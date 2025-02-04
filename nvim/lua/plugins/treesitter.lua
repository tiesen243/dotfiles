-- Register filetype and extension for treesitter
vim.filetype.add({
  extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi", mdx = "markdown" },
  pattern = {
    [".*/waybar/config"] = "jsonc",
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/hypr/.+%.conf"] = "hyprlang",
  },
})
vim.treesitter.language.register("bash", "kitty")
vim.treesitter.language.register("markdown", "mdx")

return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>",      desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      auto_install = false,
      sync_install = true,
      ensure_installed = { "bash", "lua", "hyprlang" },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    main = "nvim-treesitter.configs",
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
