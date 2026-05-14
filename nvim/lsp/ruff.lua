---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = { settings = { logLevel = "error" } },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {},
}
