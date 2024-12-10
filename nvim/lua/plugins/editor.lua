return {
  -- Keymap hint
  -- https://github.com/folke/which-key.nvim
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
          { "<leader>b",  group = "Buffers" },
          { "<leader>c",  group = "Code" },
          { "<leader>f",  group = "Finder" },
          { "<leader>g",  group = "Git" },
          { "<leader>q",  group = "Quit" },
          { "<leader>t",  group = "Terminal" },
          { "<leader>gc", group = "Copilot" },
          { "<leader>u",  group = "UI" },
        },
      },
    },
  },

  -- Telescope
  -- https://github.com/nvim-telescope/telescope.nvim
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
        { "<leader>fg", builtin.live_grep,                    desc = "Live Grep" },
        { "<leader>ff", builtin.find_files,                   desc = "Find Files" },
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

  -- Snacks: A collection of small QoL plugins for Neovim
  -- https://github.com/folke/snacks.nvim
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
      },

      animate = {},
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scroll = {},
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  -- https://github.com/lewis6991/gitsigns.nvim
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
