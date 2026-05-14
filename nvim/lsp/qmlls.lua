---@type vim.lsp.Config
return {
  cmd = { "qmlls", "-E" },
  filetypes = { "qml", "qmljs" },
  root_markers = { ".git" },
}
