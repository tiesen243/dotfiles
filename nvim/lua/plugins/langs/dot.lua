vim.lsp.enable("bashls")

---@type string
local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

---@param path string
local function have(path)
  return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
end

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = function()
      vim.filetype.add({
        extension = { rasi = "conf", rofi = "conf", wofi = "conf" },
        pattern = {
          [".*/waybar/config"] = "jsonc",
          [".*/mako/config"] = "dosini",
          [".*/kitty/.+%.conf"] = "kitty",
          [".*/hypr/.+%.conf"] = "hyprlang",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })
      vim.treesitter.language.register("bash", "kitty")

      local ensure_installed = { "bash", "git_config" }

      if have("hypr") then
        table.insert(ensure_installed, "hyprlang")
      end

      if have("fish") then
        table.insert(ensure_installed, "fish")
      end

      if have("rofi") or have("wofi") then
        table.insert(ensure_installed, "rasi")
      end

      return {
        ensure_installed = ensure_installed,
      }
    end,
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "bash-language-server", "shfmt" },
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },
}
