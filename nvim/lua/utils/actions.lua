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

M.google_search = function()
  vim.ui.input({ prompt = "Search Google: " }, function(input)
    if input == nil or input == "" then -- Esc or nil to quit google_search
      vim.api.nvim_input("<Esc>")
      return
    end
    if input and input ~= "" then
      local encoded_query = input:gsub(" ", "+") -- Replace spacebar to "+"
      local url = "https://www.google.com/search?q=" .. encoded_query
      local open_cmd = "xdg-open" -- Use "open" for macOS, "start" for Windows
      os.execute(open_cmd .. " '" .. url .. "'")
    end
  end)
end

return M
