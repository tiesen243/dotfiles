-- Register filetype and extension for treesitter
vim.filetype.add {
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  extension = {
    mdx = 'markdown',
  },
}
vim.treesitter.language.register('markdown', 'mdx')

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  callback = function()
    vim.lsp.buf.format { timeout = 2000 }
  end,
})

return {
  -- Code Completion
  -- https://github.com/hrsh7th/nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local defaults = require 'cmp.config.default' ()
      local cmp = require 'cmp'

      cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

      return {
        completion = { competeopt = 'menu,menuone,preview,noselect' },
        preselect = cmp.PreselectMode.Item,
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<S-Tab>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Replace },
          ['<Tab>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Replace },
          ['<C-k>'] = cmp.mapping.scroll_docs(-4),
          ['<C-j>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = false },
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'snippets' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                item.kind = icon
                item.kind_hl_group = hl_group
                return item
              end
            end

            item.kind = Yuki.icons.kinds[item.kind] or ''

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 30,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 20,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
              end
            end

            return item
          end,
        },
        experimental = { ghost_text = { hl_group = 'CmpGhostText' } },
        sorting = defaults.sorting,
      }
    end,
  },

  -- Snippets engine
  -- https://github.com/garymjr/nvim-snippets
  {
    'garymjr/nvim-snippets',
    dependencies = 'rafamadriz/friendly-snippets',
    opts = { friendly_snippets = true },
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

  -- Auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = { check_ts = true, fast_wrap = {} },
  },

  -- Comment toggler
  -- https://github.com/numToStr/Comment.nvim
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    opts = {
      pre_hook = function()
        return vim.bo.commentstring
      end,
    },
  },
}
