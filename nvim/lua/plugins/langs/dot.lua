vim.lsp.enable("bashls")
vim.filetype.add({
  extension = { rasi = "conf", rofi = "conf", wofi = "conf" },
  pattern = {
    [".*/kitty/.+%.conf"] = "kitty",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
vim.treesitter.language.register("bash", "kitty")

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "bash", "git_config" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "bash-language-server", "shfmt" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },
}
