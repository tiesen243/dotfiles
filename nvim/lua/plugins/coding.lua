return {
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "zbirenbaum/copilot-cmp", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "onsails/lspkind-nvim",
    },

    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = require("lspkind").cmp_format({
            maxwidth = 50,
            ellipsis_char = "",
            preset = "codicons",
            mode = "symbol_text",
            symbol_map = { Copilot = "" },
          }),
        },
        experimental = { ghost_text = { hl_group = "CmpGhostText" } },
        sorting = defaults.sorting,
      }
    end,
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      return { history = true, delete_check_events = "TextChanged" }
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" }, ["_"] = { "prettier" } },
      format_on_save = { timeout_ms = 500 },
    },
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = true,
      sync_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    opts = { check_ts = true, fast_wrap = {} },
  },

  -- colorize hex colors in the buffer
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      --- @type string | "foreground" | "background" | "virtualtext"
      mode = "background", -- Set the display mode.
      virtualtext = "■",
      --- @type boolean | "normal" | "lsp" | "both"
      tailwind = "lsp", -- Enable tailwind colors
    },
  },
}
