return {
  -- Code Completion
  -- https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true

      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

      local kind_icons = {
        Text = "󰉿",
        Method = "m",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰆧",
        Class = "󰌗",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰇽",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      }

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
          ["<C-e>"] = cmp.mapping.close(),
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
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              snippets = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
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
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    opts = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          require("none-ls.code_actions.eslint"),
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.shfmt.with({ args = { "-i", "4" } }),
          nls.builtins.formatting.stylua,
          require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
          require("none-ls.formatting.ruff_format"),
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
    main = "nvim-treesitter.configs",
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
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- Auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
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
