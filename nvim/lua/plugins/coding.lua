return {
  "https://github.com/rafamadriz/friendly-snippets",

  {
    {
      name = "blink-cmp",
      src = "https://github.com/saghen/blink.cmp",
      version = "v1"
    },
    opts = {
      snippets = {
        expand = function(snippet, _)
          return Yuki.cmp.expand(snippet)
        end,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
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
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = false },
        },
      },
      signature = { enabled = false },
      keymap = { preset = "super-tab" },
    },
  },

  {
    {
      name = "conform",
      src = "https://github.com/stevearc/conform.nvim",
    },
    opts = function()
      return {
        default_format_opts = {
          lsp_format = "fallback",
        },
        postinstall = function()
          Yuki.format.register({
            priority = 1000,
            name = "Conform",
            active = function(bufnr)
              local ret = require("conform").list_formatters(bufnr)
              return #(vim.tbl_map(function(v)
                return v.name
              end, ret)) > 0
            end,
            command = function(bufnr)
              require("conform").format({ bufnr = bufnr, timeout = 2000 })
            end,
          })
        end,
      }
    end,
  },

  {
    {
      name = "nvim-treesitter",
      src = "https://github.com/nvim-treesitter/nvim-treesitter",
    },
    opts = {
      auto_install = false,
      sync_install = true,

      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },

      ensure_installed = {
        "diff",
      },
      postinstall = function(opts)
        local TS = require("nvim-treesitter")

        if not TS.get_installed then
          return vim.notify("[nvim-treesitter] Your nvim-treesitter is outdated.", vim.log.levels.ERROR)
        elseif type(opts.ensure_installed) ~= "table" then
          return vim.notify("[nvim-treesitter] opts.ensure_installed must be a table.", vim.log.levels.ERROR)
        end

        TS.setup(opts)
        Yuki.treesitter.get_installed(true)

        local install = vim.tbl_filter(function(lang)
          return not Yuki.treesitter.have(lang)
        end, opts.ensure_installed or {})
        if #install > 0 then
          Yuki.treesitter.build(function()
            TS.install(install, { summary = true }):await(function()
              Yuki.treesitter.get_installed(true)
            end)
          end)
        end

        vim.api.nvim_create_autocmd("FileType", {
          group = Yuki.utils.create_augroup("treesitter"),
          callback = function(ev)
            local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
            if not Yuki.treesitter.have(ft) then
              return
            end

            ---@param feat string
            ---@param query string
            local function enabled(feat, query)
              local f = opts[feat] or {}
              return f.enable ~= false
                and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
                and Yuki.treesitter.have(ft, query)
            end

            -- highlighting
            if enabled("highlight", "highlights") then
              pcall(vim.treesitter.start, ev.buf)
            end
          end,
        })
      end,
    },
  },

  {
    { src = "https://github.com/windwp/nvim-autopairs" },
    opts = {},
  },

  {
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    opts = {},
  },
}
