vim.filetype.add({ extension = { mdx = "markdown" } })
vim.treesitter.language.register("markdown", "mdx")

return {
  -- Add markdown to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "markdown", "markdown_inline" } },
  },

  -- setup formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
      },
    },
  },

  -- Markdown preivew in Neovim
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion", "markdown.mdx" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },
}
