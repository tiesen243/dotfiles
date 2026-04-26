local M = {}

M.check = function()
  local health = vim.health
  health.start("Yuki")

  local plugin_ok, _ = pcall(require, "yuki.plugin")
  if not plugin_ok then
    health.error("Failed to load Yuki plugin module")
  else
    health.ok("Yuki plugin module loaded successfully")
  end

  local configs_ok, _ = pcall(require, "yuki.configs")
  if not configs_ok then
    health.error("Failed to load Yuki configs module")
  else
    health.ok("Yuki configs module loaded successfully")
  end

  local cmp_ok, _ = pcall(require, "yuki.cmp")
  if not cmp_ok then
    health.error("Failed to load Yuki cmp module")
  else
    health.ok("Yuki cmp module loaded successfully")
  end

  local format_ok, _ = pcall(require, "yuki.format")
  if not format_ok then
    health.error("Failed to load Yuki format module")
  else
    health.ok("Yuki format module loaded successfully")
  end

  local treesitter_ok, _ = pcall(require, "yuki.treesitter")
  if not treesitter_ok then
    health.error("Failed to load Yuki treesitter module")
  else
    health.ok("Yuki treesitter module loaded successfully")
  end

  local utils_ok, _ = pcall(require, "yuki.utils")
  if not utils_ok then
    health.error("Failed to load Yuki utils module")
  else
    health.ok("Yuki utils module loaded successfully")
  end
end

return M
