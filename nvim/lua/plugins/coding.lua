-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  callback = function()
    pcall(vim.lsp.buf.format, { timeout = 2000 })
  end,
})

-- Hide copilot suggestions when cmp menu is open
vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    vim.b.copilot_enabled = false
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    vim.b.copilot_enabled = true
  end,
})

return {
  -- Code Completion
  -- https://github.com/saghen/blink.cmp
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      appearance = {
        nerd_font_variant = 'mono',
        use_nvim_cmp_as_default = false,
        kind_icons = vim.tbl_extend('keep', { Color = '██' }, Yuki.icons.kinds),
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { draw = { treesitter = { 'lsp' } } },
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        ghost_text = { enabled = true },
      },
      keymap = {
        preset = 'none',
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-Space>'] = { 'show', 'hide', 'fallback' },
        ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
      },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
    opts_extend = { 'sources.default' },
  },

  -- Formatter
  -- https://github.com/nvimtools/none-ls.nvim
  {
    'nvimtools/none-ls.nvim',
    opts = function()
      local nls = require 'null-ls'

      nls.setup {
        sources = {
          Yuki.lang.react and nls.builtins.formatting.prettier,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },

  -- Auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = { check_ts = true, fast_wrap = {} },
  },

  -- Comment toggler
  -- https://github.com/folke/ts-comments.nvim
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
