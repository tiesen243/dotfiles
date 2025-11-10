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
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "File Explorer",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Snacks.git.get_root() })
        end,
        desc = "File Explorer (root)",
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
        indent = { with_expanders = false },
        icon = { folder_closed = "", folder_open = "", folder_empty = "" },
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
          ["h"] = "close_node",
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
      -- Find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fi", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fP", function() Snacks.picker.pick() end, desc = "Picker List" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
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
      dashboard = { example = "doom", preset = { header = Yuki.configs.logo } },
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
        theme_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/../lazygit/config.yml"),
      },
    },
  },
}
