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
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
              vim.notify("Path copied to clipboard", "info", { title = "NeoTree" })
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
      { "<leader><space>", Snacks.picker.buffers, desc = "Buffers" },
      -- Find
      { "<leader>fg", Snacks.picker.grep, desc = "Grep" },
      { "<leader>ff", Snacks.picker.files, desc = "Find Files" },
      { "<leader>fp", Snacks.picker.projects, desc = "Projects" },
      { "<leader>fP", Snacks.picker.pick, desc = "Picker List" },
      { "<leader>fr", Snacks.picker.recent, desc = "Recent" },
      { "<leader>fi", Snacks.picker.icons, desc = "Icons" },
      -- Git
      { "<leader>gb", Snacks.picker.git_branches, desc = "Git Branches" },
      { "<leader>gB", Snacks.gitbrowse, desc = "Git Browse (open)" },
      { "<leader>gl", Snacks.picker.git_log, desc = "Git Log" },
      { "<leader>gL", Snacks.picker.git_log_line, desc = "Git Log Line" },
      { "<leader>gs", Snacks.picker.git_status, desc = "Git Status" },
      { "<leader>gS", Snacks.picker.git_stash, desc = "Git Stash" },
      { "<leader>gd", Snacks.picker.git_diff, desc = "Git Diff (Hunks)" },
      { "<leader>gf", Snacks.picker.git_log_file, desc = "Git Log File" },
    },
    opts = {
      bigfile = { enabled = true },
      dashboard = { preset = { header = Yuki.logo } },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true, icons = Yuki.icons.diagnostics },
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
    init = function()
      vim.api.nvim_create_autocmd("Snacks Toggle", {
        group = Yuki.utils.create_augroup("snacks_toggle"),
        pattern = "VeryLazy",
        callback = function()
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
        end,
      })
    end,
  },
}
