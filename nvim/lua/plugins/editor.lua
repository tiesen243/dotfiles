vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*lazygit",
  callback = function()
    if package.loaded["neo-tree.sources.git_status"] then
      require("neo-tree.sources.git_status").refresh()
    end
  end,
})

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Snacks.git.get_root() })
        end,
        desc = "File Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
    },
    opts = {
      default_component_configs = {
        indent = {
          with_expanders = false,
          padding = 0,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          provider = function(icon, node)
            if node.type == "file" or node.type == "terminal" then
              local success, web_devicons = pcall(require, "nvim-web-devicons")

              local name = node.name
              if node.type == "terminal" then
                name = "terminal"
              elseif node.name:match("^%.env") then
                name = "env"
              elseif node.name:match("^Dockerfile") then
                name = "Dockerfile"
              elseif node.name:match("^docker%-compose.*%.yml$") then
                name = "docker-compose.yml"
              end

              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = hl or icon.highlight
              end
            end
          end,
        },
      },
      nesting_rules = Yuki.configs.nesting_rules,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ["h"] = "toggle_hidden",
          ["l"] = "toggle_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
              vim.notify("Path copied to clipboard", vim.log.levels.INFO, { title = "NeoTree" })
            end,
            desc = "Copy Path to Clipboard",
          },

          ["H"] = "noop",
          ["<space>"] = "noop",
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    keys = {
      -- stylua: ignore start
      { "<leader><space>", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- Find
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fP", function() Snacks.picker.pick() end, desc = "Picker List" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fi", function() Snacks.picker.icons() end, desc = "Icons" },
      -- Git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse (open)" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- stylua: ignore end
    },
    opts = {
      bigfile = { enabled = true },
      dashboard = { preset = { header = Yuki.configs.logo } },
      explorer = { enabled = true },
      indent = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true, icons = Yuki.configs.icons.diagnostics },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },

      lazygit = {
        configure = false,
        config = {
          theme = {
            [241] = { fg = "Special" },
            activeBorderColor = { fg = "#a96249", bold = true },
            inactiveBorderColor = { fg = "#46120d" },
            searchingActiveBorderColor = { fg = "#a96249", bold = true },
            optionsTextColor = { fg = "#f2f4f8" },
            selectedLineBgColor = { bg = "#2a2a2a" },
            cherryPickedCommitFgColor = { fg = "#a96249" },
            cherryPickedCommitBgColor = { bg = "#be95ff" },
            markedBaseCommitFgColor = { fg = "#a96249" },
            markedBaseCommitBgColor = { bg = "#08bdba" },
            unstagedChangesColor = { fg = "#ee5396" },
            defaultFgColor = { fg = "#f2f4f8" },
          },
        },
      },
    },
  },
}
