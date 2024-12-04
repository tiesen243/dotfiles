return {
  -- Keymap hint
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = "modern",
      triggers = { { "<leader>", mode = "n" } },
      spec = {
        {
          mode = { "n" },
          { "<leader>b", group = "Buffers" },
          { "<leader>c", group = "Code" },
          { "<leader>f", group = "Finder" },
          { "<leader>g", group = "Git" },
          { "<leader>q", group = "Quit" },
          { "<leader>t", group = "Terminal" },
          { "<leader>gc", group = "Copilot" },
          { "<leader>u", group = "UI" },
        },
      },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = function()
      local builtin = require("telescope.builtin")
      local extensions = require("telescope").extensions

      return {
        { "<leader>fg", builtin.live_grep, desc = "Live Grep" },
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fe", extensions.file_browser.file_browser, desc = "File Browser" },
      }
    end,
    opts = function()
      local actions = require("telescope.actions")
      require("telescope").load_extension("file_browser")

      return {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      }
    end,
  },

  -- Snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
 ╚████╔╝ ██║   ██║█████╔╝ ██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║
   ██║   ╚██████╔╝██║  ██╗██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
          ]],
        },

        sections = {
          { section = "header" },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
          { section = "keys", gap = 1, padding = 1, pane = 2 },
        },
      },

      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        ignore_whitespace = true,
      },
    },
  },
}
