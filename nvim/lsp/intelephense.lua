---@type vim.lsp.Config
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { ".git", "composer.json" },
  settings = {
    intelephense = {
      telemetry = {
        enabled = false,
      },
    },
  },
}
