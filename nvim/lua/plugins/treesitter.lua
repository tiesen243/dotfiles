-- Register filetype and extension for treesitter
vim.filetype.add {
  extension = { rasi = 'rasi', rofi = 'rasi', wofi = 'rasi', mdx = 'markdown' },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/kitty/.+%.conf'] = 'kitty',
    ['.*/hypr/.+%.conf'] = 'hyprlang',
  },
}
vim.treesitter.language.register('bash', 'kitty')
vim.treesitter.language.register('markdown', 'mdx')

return {
  -- Treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy',
    main = 'nvim-treesitter.configs',
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = true,
      sync_install = true,
      indent = { enable = true },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
    },
  },

  -- Automatically add closing tags for HTML and JSX
  -- https://github.com/windwp/nvim-ts-autotag
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
}
