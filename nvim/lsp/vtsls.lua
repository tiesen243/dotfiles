local inlayHintsConfig = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

local preferences = {
  importModuleSpecifier = "non-relative",

  autoImportSpecifierExcludeRegexes = {
    "@base-ui/react",
    "next/dist",
    "next/router",
    "radix-ui",
  },
}

local filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}
local globalPlugins = {}

if vim.fn.executable("vue-language-server") == 1 then
  local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
    languages = { "vue" },
    configNamespace = "typescript",
    enableForWorkspaceTypeScriptVersions = true,
  }
  table.insert(globalPlugins, vue_plugin)
  table.insert(filetypes, "vue")
end

---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = filetypes,
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })
    -- exclude deno
    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      -- deno lock is closer than package manager lock, abort
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      -- deno config is closer than or equal to package manager lock, abort
      return
    end
    -- project is standard TS, not deno
    -- We fallback to the current working directory if no project root is found
    on_dir(project_root or vim.fn.getcwd())
  end,
  settings = {
    typescript = {
      updateImportsOnFileMove = "always",
      inlayHints = inlayHintsConfig,
      preferences = preferences,
    },
    javascript = {
      updateImportsOnFileMove = "always",
      inlayHints = inlayHintsConfig,
      preferences = preferences,
    },
    vtsls = {
      autoUseWorkspaceTsdk = true,
      enableMoveToFileCodeAction = true,
      experimental = {
        maxInlayHintLength = 30,
      },
      tsserver = {
        globalPlugins = globalPlugins,
      },
    },
  },
}
