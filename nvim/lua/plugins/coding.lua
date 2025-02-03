-- auto format
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("yuki_format_on_save", { clear = true }),
  callback = function()
    pcall(vim.lsp.buf.format, { timeout = 2000 })
  end,
})

return {
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
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },

      keymap = { preset = "super-tab" },
    },
  },

  -- Formatter
  -- https://github.com/nvimtools/none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")

      nls.setup({
        sources = {
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
        },
      })
    end,
  },

  -- Auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true, fast_wrap = {} },
  },
}
