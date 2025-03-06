return {
  -- add prisma to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "prisma" },
    },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        prismals = {},
      },
      setup = {
        prismals = function()
          if not Yuki.configs.auto_format then
            return
          end

          local function get_client(buf)
            return Yuki.lsp.get_clients({ name = "prismals", bufnr = buf })[1]
          end

          local formatter = Yuki.lsp.formatter({
            name = "prismals: lsp",
            primary = false,
            priority = 200,
            filter = "prismals",
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "prismals: Format"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "prismals" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                vim.lsp.buf.format({ bufnr = buf, timeout = 2000 })
              end
            end
          end

          -- register the formatter with Yuki
          Yuki.format.register(formatter)
        end,
      },
    },
  },
}
