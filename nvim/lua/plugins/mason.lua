local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

return {
  {
    {
      name = "mason",
      src = "https://github.com/mason-org/mason.nvim",
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = { "tree-sitter-cli" },
      postinstall = function(opts)
        local mr = require("mason-registry")
        mr.refresh(function()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              vim.notify("Installing " .. tool .. "...", vim.log.levels.INFO, { title = "Mason" })
              p:install()
            end
          end
        end)
      end,
    },
  },
}
