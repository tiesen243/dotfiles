---@type vim.lsp.Config
return {
  filetypes = { "kotlin" },
  cmd = { "intellij-server", "--stdio" },
  root_markers = {
    "settings.gradle", -- Gradle (multi-project)
    "settings.gradle.kts", -- Gradle (multi-project)
    "pom.xml", -- Maven
    "build.gradle", -- Gradle
    "build.gradle.kts", -- Gradle
    "workspace.json", -- Used to integrate your own build system
  },
}
