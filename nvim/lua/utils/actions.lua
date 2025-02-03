local M = {}

---@param t table
---@param key string
---@param values table
M.extend = function(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

---@param method string|string[]
M.has = function(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@param direction string | 'h' | 'j' | 'k' | 'l'
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
