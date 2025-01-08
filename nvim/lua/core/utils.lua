local M = {}

M.lsp_attach = function(client, bufnr)
  local map = function(key, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
  end

  local builtin = require("telescope.builtin")
  map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  map("gr", builtin.lsp_references, "[G]oto [R]eferences")
  map("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")

  map("<C-k>", vim.lsp.buf.signature_help, "Signature help", { "i", "n" })
  map("<C-j>", vim.lsp.buf.hover, "[H]over doc", { "i", "n" })

  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
  map("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
  map("<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")
  map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  map("<leader>cR", Snacks.rename.rename_file, "[C]ode [R]ename file")
  map("<leader>cs", builtin.lsp_document_symbols, "[C]ode Document [S]ymbols")
  map("<leader>ct", builtin.lsp_type_definitions, "[C]ode [T]ype Definition")
  map("<leader>cw", builtin.lsp_dynamic_workspace_symbols, "[C]ode [W]orkspace Symbols")

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

M.navigate = function(direction)
  local mappings = { h = "left", j = "bottom", k = "top", l = "right" }
  local left_win = vim.fn.winnr("1" .. direction)
  if vim.fn.winnr() ~= left_win then
    vim.api.nvim_command("wincmd " .. direction)
  else
    local command = "kitty @ kitten navigate_kitty.py " .. mappings[direction]
    vim.fn.system(command)
  end
end

M.get_battery_state = function()
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
end

M.get_time = function()
  return " " .. os.date("%R")
end

return M

