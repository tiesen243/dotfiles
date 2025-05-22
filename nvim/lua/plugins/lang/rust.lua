vim.lsp.enable("rust_analyzer")

Yuki.format.register({
  priority = 200,
  name = "RustFmt",
  active = function(bufnr)
    local client = vim.lsp.get_clients({ name = "rust_analyzer", bufnr = bufnr })[1]
    return client ~= nil
  end,
  command = function(bufnr)
    local client = vim.lsp.get_clients({ name = "rust_analyzer", bufnr = bufnr })[1]
    if client then
      vim.cmd("RustFmt")
    end
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "rust" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "rust-analyzer" } },
  },
}
