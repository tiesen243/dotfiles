return {
  -- auto completion
  -- https://github.com/saghen/blink.cmp
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = { "sources.default" },
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    opts = {
      snippets = {
        expand = function(snippet, _)
          return Yuki.cmp.expand(snippet)
        end,
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", Yuki.icons.kinds, { Color = "██" }),
      },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
        list = { selection = { preselect = true, auto_insert = true } },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      keymap = { preset = "super-tab" },
    },
  },

  -- formatter
  -- https://github.com/stevearc/conform.nvim
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    init = function()
      Yuki.format.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end,
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },

  -- auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true, fast_wrap = {} },
  },
}
