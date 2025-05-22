vim.lsp.enable("bashls")

---@type string
local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

---@param path string
local function have(path)
  ---@diagnostic disable-next-line: undefined-field
  return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      local function add(lang)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, lang)
        end
      end

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

      add("bash")
      add("git_config")

      if have("hypr") then
        add("hyprlang")
      end

      if have("fish") then
        add("fish")
      end

      if have("rofi") or have("wofi") then
        add("rasi")
      end
    end,
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "bash-language-server", "shfmt" } },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
}
