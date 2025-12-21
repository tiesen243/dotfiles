vim.lsp.enable("eslint")

Yuki.format.register({
  priority = 200,
  name = "LspEslintFixAll",
  active = function(bufnr)
    local client = vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })[1]
    return client ~= nil
  end,
  command = function(bufnr)
    local client = vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })[1]
    if client then
      local diag = vim.diagnostic.get(bufnr)

      for _, d in ipairs(diag) do
        if d.source == "eslint" then
          vim.cmd("LspEslintFixAll")
          vim.cmd("sleep 100m")
          break
        end
      end
    end
  end,
})

return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "eslint_lsp" } },
  },
}
