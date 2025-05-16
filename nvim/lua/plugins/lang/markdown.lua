vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "markdown" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier" },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    opts = {
      code = { width = "block", border = "thick" },
      completions = { blink = { enabled = true } },
      indent = { enabled = true, skip_heading = true },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
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
