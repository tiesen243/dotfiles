-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LspFormatting', {}),
  callback = function()
    pcall(vim.lsp.buf.format, { timeout = 2000 })
  end,
})

return {
  -- Code Completion
  -- https://github.com/hrsh7th/nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require 'cmp'
      local defaults = require 'cmp.config.default' ()

      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      return {
        completion = { completeopt = 'menu,menuone,noinsert,noselect' },
        preselect = cmp.PreselectMode.Item,
        snippet = {
          expand = function(args)
            return vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping.scroll_docs(-4),
          ['<C-j>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            else
              fallback()
            end
          end, { 'i' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            else
              fallback()
            end
          end, { 'i' }),
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm { select = true }
            else
              fallback()
            end
          end, { 'i' }),
          ['<C-Space>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end, { 'i' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'snippets' },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, item)
            item.kind = (Yuki.icons.kinds[item.kind] or '')

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 30,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 20,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
              end
            end

            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                item.kind = icon
                item.kind_hl_group = hl_group
                return item
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

  -- Snippets
  {
    'garymjr/nvim-snippets',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      create_cmp_source = true,
      friendly_snippets = true,
    },
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
