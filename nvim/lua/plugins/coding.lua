return {
  -- Code Completion
  -- https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true

      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-S-Space>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            select = auto_select,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
        }),
        sources = cmp.config.sources({
          { name = "snippets" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = require("lspkind").cmp_format({
            maxwidth = 50,
            ellipsis_char = "",
            preset = "codicons",
            mode = "symbol_text",
          }),
        },
        sorting = defaults.sorting,
      }
    end,
  },

  {
    "garymjr/nvim-snippets",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = { create_cmp_source = true, friendly_snippets = true },
  },

  -- Formatter
  -- https://github.com/nvimtools/none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
        },
      })
    end,
  },

  -- Treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = true,
      sync_install = true,
      indent = { enable = true },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
    },
    config = function(_, opts)
      vim.g.skip_ts_context_commentstring_module = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  -- https://github.com/windwp/nvim-ts-autotag
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- Auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    opts = { check_ts = true, fast_wrap = {} },
  },

  -- Comment toggler
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      toggler = { line = "<C-/>" },
      opleader = { line = "<C-/>" },
      pre_hook = function()
        return vim.bo.commentstring
      end,
    },
  },
}
