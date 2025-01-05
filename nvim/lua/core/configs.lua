-- Leader key (default is space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

_G.Yuki = {
  lang = {
    java = true,
    python = true,
    react = true,
  },
  colorcheme = "tokyonight",
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    git_signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    git_signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    kind = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = "󱄽 ",
      String = " ",
      Struct = " ",
      Supermaven = " ",
      TabNine = "󰏚 ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
  logo = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
 ╚████╔╝ ██║   ██║█████╔╝ ██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║
   ██║   ╚██████╔╝██║  ██╗██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
   ]],
  get_battery_state = function()
    local capacity = io.open("/sys/class/power_supply/BAT1/capacity", "r")
    local status = io.open("/sys/class/power_supply/BAT1/status", "r")

    if capacity == nil or status == nil then
      return
    end

    local capacity_value = tonumber(capacity:read("*all"))
    local status_value = status:read("*all")
    local icon = "󰁻"

    if status_value:match("Charging") then
      icon = "󰂅"
    elseif capacity_value == 100 then
      icon = "󰁹"
    elseif capacity_value >= 80 then
      icon = "󰂁"
    elseif capacity_value >= 60 then
      icon = "󰁿"
    elseif capacity_value >= 40 then
      icon = "󰁾"
    elseif capacity_value >= 20 then
      icon = "󰁽"
    else
      icon = "󰁻"
    end

    capacity:close()
    status:close()

    return icon .. " " .. tostring(capacity_value)
  end,
  get_time = function()
    return " " .. os.date("%R")
  end,
}
