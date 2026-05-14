vim.filetype.add({
  pattern = {
    [".*/typescript/.*%.json"] = "jsonc",
    [".*/tsconfig.*%.json"] = "jsonc",
  },
})

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = "vscode-json-language-server"
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
  end,
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  root_markers = { ".git" },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "composer.json" },
          url = "https://getcomposer.org/schema.json",
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig",
        },
      },
    },
  },
}
