vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "markdown", "markdown_inline" },
    },
  },
}
