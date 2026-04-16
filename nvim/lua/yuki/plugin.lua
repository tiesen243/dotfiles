local M = {}

local PLUGINS = {}
local CONFIGS = {}
local KEYS = {}

M.stats = {
  loaded = 0,
  time = 0,
}

M.get_name = function(src)
  return src:match(".*/(.*)$"):gsub("%.nvim$", ""):gsub("%.git$", "")
end

M.load = function(plugins)
  local start = vim.loop.hrtime()

  for _, file in ipairs(plugins) do
    for _, plugin in ipairs(require(file)) do
      if type(plugin) == "string" then
        table.insert(PLUGINS, plugin)
        goto continue
      end

      local name = plugin[1].name or M.get_name(plugin[1].src)

      if not plugin[1].override then
        table.insert(PLUGINS, plugin[1])
      end

      if plugin.opts then
        if plugin[1].override and CONFIGS[name] then
          if type(plugin.opts) == "function" then
            local new_opts = plugin.opts(CONFIGS[name])
            CONFIGS[name] = Yuki.utils.merge(CONFIGS[name], new_opts or {})
          else
            CONFIGS[name] = Yuki.utils.merge(CONFIGS[name], plugin.opts)
          end
        else
          if type(plugin.opts) == "function" then
            CONFIGS[name] = plugin.opts({})
          else
            CONFIGS[name] = plugin.opts
          end
        end
      end

      if plugin.keys then
        KEYS[name] = plugin.keys
      end

      ::continue::
    end
  end

  vim.pack.add(PLUGINS)

  for name, opts in pairs(CONFIGS) do
    local status_ok, plugin = pcall(require, name)
    if not status_ok then
      goto continue
    end

    if type(opts) == "function" then
      opts = opts()
    end

    local postinstall = opts.postinstall
    opts.postinstall = nil

    plugin.setup(opts)

    if type(postinstall) == "function" then
      postinstall(opts)
    end
    M.stats.loaded = M.stats.loaded + 1

    ::continue::
  end

  for _, keys in pairs(KEYS) do
    for _, key in ipairs(keys) do
      local lhs = key[1]
      local rhs = key[2]
      local opts = key[3] or {}

      Yuki.utils.map(lhs, rhs, opts.desc, opts)
    end
  end

  M.stats.time = (vim.loop.hrtime() - start) / 1e6 -- convert to ms
end

M.format_plugins = function()
  local Tree = require("nui.tree")
  local Node = Tree.Node

  local data = vim.pack.get()
  local nodes = {}

  for _, p in ipairs(data) do
    local name = p.spec.name or "unknown"
    local icon = p.active and "●" or "○"

    local children = {
      Node({ text = "  Path: " .. p.path }),
      Node({ text = "  Active: " .. tostring(p.active) }),
      Node({ text = "  Branch: " .. (p.branches and p.branches[1] or "none") }),
    }

    table.insert(
      nodes,
      Node({
        id = name,
        text = icon .. " " .. name,
        meta = p,
      }, children)
    )
  end

  return nodes, #data
end

M.open = function()
  local Popup = require("nui.popup")
  local Tree = require("nui.tree")
  local Line = require("nui.line")

  local nodes, count = M.format_plugins()

  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = " Yuki Plugins (" .. count .. ")",
        top_align = "center",
        bottom = string.format(" ⚡ %d / %d plugins loaded in %.2f ms ", M.stats.loaded, count, M.stats.time),
        bottom_align = "center",
      },
      padding = { 0, 2 },
    },
    position = "50%",
    size = {
      width = "60%",
      height = "70%",
    },
  })

  popup:mount()

  local tree = Tree({
    bufnr = popup.bufnr,
    nodes = nodes,
    prepare_node = function(node)
      local line = Line()

      if node:has_children() then
        local icon = node:is_expanded() and " " or " "
        local hl = node.meta and (node.meta.active and "String" or "Comment") or "Normal"

        line:append(icon .. node.text, hl)
      else
        line:append(node.text, "Comment")
      end

      return line
    end,
  })

  tree:render()

  vim.keymap.set("n", "q", function()
    popup:unmount()
  end, { buffer = popup.bufnr })

  vim.keymap.set("n", "<CR>", function()
    local node = tree:get_node()
    if not (node and node:has_children()) then
      return
    end

    (node:is_expanded() and node.collapse or node.expand)(node)
    tree:render()
  end, { buffer = popup.bufnr })

  vim.keymap.set("n", "l", function()
    local node = tree:get_node()
    if node and node:has_children() then
      node:expand()
      tree:render()
    end
  end, { buffer = popup.bufnr })

  vim.keymap.set("n", "h", function()
    local node = tree:get_node()
    if node and node:has_children() then
      node:collapse()
      tree:render()
    end
  end, { buffer = popup.bufnr })

  vim.keymap.set("n", "u", function()
    local node = tree:get_node()
    if node and node:has_children() then
      vim.pack.update({ node.meta.spec.name })
      tree:render()
    end
  end, { buffer = popup.bufnr })

  vim.keymap.set("n", "U", function()
    vim.pack.update()
    tree:render()
  end, { buffer = popup.bufnr })

  vim.keymap.set("n", "d", function()
    local node = tree:get_node()
    if node and node:has_children() then
      vim.pack.del({ node.meta.spec.name })
      tree:render()
    end
  end, { buffer = popup.bufnr })
end

return M
