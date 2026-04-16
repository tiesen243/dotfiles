return {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",

  {
    {
      name = "neo-tree",
      src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
      version = vim.version.range("3"),
    },
    opts = {
      default_component_configs = {
        container = { enable_character_fade = true },
        symlink_target = { enabled = true },
        indent = { with_expanders = false },
        icon = { folder_closed = "", folder_open = "", folder_empty = "" },
      },
      close_if_last_window = true,
      clipboard = { sync = "global" },
      use_libuv_file_watcher = false,
      nesting_rules = Yuki.configs.nesting_rules,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = false },
        filtered_items = {
          hide_by_pattern = { "node_modules", "dist", "build" },
          always_show_by_pattern = { ".env*" },
        },
      },
      window = {
        position = "left",
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
          ["O"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()

              local open_cmd
              if vim.fn.has("mac") == 1 then
                open_cmd = "open"
              elseif vim.fn.has("unix") == 1 then
                open_cmd = "xdg-open"
              elseif vim.fn.has("win32") == 1 then
                open_cmd = "start"
              else
                vim.notify("Unsupported OS for opening files", vim.log.levels.ERROR, { title = "NeoTree" })
                return
              end

              vim.fn.jobstart({ open_cmd, path }, { detach = true })
            end,
            desc = "Open in Default Application",
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        { desc = "File Explorer" },
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        { desc = "Buffer Explorer" },
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        { desc = "Git Explorer" },
      },
    },
  },

  {
    { src = "https://github.com/folke/snacks.nvim" },
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
      dashboard = {
        preset = { header = Yuki.configs.logo },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
        },
      },
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

      postinstall = function()
			  -- buffers
        -- stylua: ignore start
        Yuki.utils.map("<leader>bb", "<cmd>e #<cr>",  "Switch to Other Buffer" )
        Yuki.utils.map("<leader>bd", function() Snacks.bufdelete() end,  "Delete Buffer" )
        Yuki.utils.map("<leader>bo", function() Snacks.bufdelete.other() end, "Delete Other Buffers" )
        Yuki.utils.map("<leader>bD", "<cmd>:bd<cr>", "Delete Buffer and Window" )
        -- stylua: ignore end

        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")

        if vim.lsp.inlay_hint then
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end

        -- stylua: ignore start
        if vim.fn.executable("lazygit") == 1 then
          ---@diagnostic disable-next-line: missing-fields
        Yuki.utils.map("<leader>gg", function() Snacks.lazygit({ cwd = Snacks.git.get_root() }) end, "Lazygit (Root Dir)")
        Yuki.utils.map("<leader>gG", function() Snacks.lazygit() end, "Lazygit (cwd)")
        end
        -- stylua: ignore end

        -- Terminal Mappings
        Yuki.utils.map("<c-/>", function()
          Snacks.terminal.toggle(nil, { cwd = Snacks.git.get_root() })
        end, "Terminal (Root Dir)")
        Yuki.utils.map("<C-/>", "<cmd>close<cr>", "Hide Terminal", { mode = "t" })
      end,
    },
  },
}
