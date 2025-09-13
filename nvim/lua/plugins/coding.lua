return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    opts = {
      appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "mono" },
      completion = {
        ghost_text = { enabled = true },
        menu = {
          draw = {
            columns = {
              { "kind_icon", "label" },
              { "label_description" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon .. " "
                    end
                  else
                    icon = Yuki.configs.icons.kinds[ctx.kind] or " "
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
            treesitter = { "lsp" },
          },
        },
      },
      keymap = { preset = "super-tab" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "stevearc/conform.nvim",
    opts = function()
      -- Yuki.format.register({
      --   priority = 1000,
      --   name = "Conform",
      --   active = function(bufnr)
      --     local ret = require("conform").list_formatters(bufnr)
      --     return #(vim.tbl_map(function(v)
      --       return v.name
      --     end, ret)) > 0
      --   end,
      --   command = function(bufnr)
      --     require("conform").format({
      --       bufnr = bufnr,
      --       timeout = 5000,
      --       async = true,
      --       lsp_fallback = true,
      --     })
      --   end,
      -- })
      return {
        default_format_opts = {
          lsp_format = "fallback",
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      }
    end,
  },

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
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      auto_install = false,
      sync_install = true,
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

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
}
