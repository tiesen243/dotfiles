return {
  -- Keymap hint
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      triggers = { { "<leader>", mode = "n" } },
      spec = {
        {
          mode = { "n" },
          { "<leader>a",     group = "AI" },
          { "<leader>b",     group = "Buffers" },
          { "<leader>c",     group = "Code" },
          { "<leader>f",     group = "Finder" },
          { "<leader>g",     group = "Git" },
          { "<leader>q",     group = "Quit" },
          { "<leader>u",     group = "UI" },
          { "<leader>w",     group = "Window" },
          { "<leader><tab>", group = "Tab" },
        },
      },
    },
  },

  -- File Explorer
  -- https:://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer" }, opts = {} },
    opts = {
      window = {
        width = 32,
        position = "left",
        mappings = {
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
        },
      },
    },
  },

  -- Statusline
  -- https://github.com/nvim-lualine/lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        disabled_filetypes = { statusline = { "snacks_dashboard", "neo-tree" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch" },
          { "filetype", icon_only = true,   separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          { "diff" },
        },
        lualine_c = { "diagnostics" },
        lualine_x = { "encoding", "fileformat", "rest" },
        lualine_y = {
          { "progress", padding = { left = 1, right = 0 }, separator = " " },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
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
    },
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        { "<leader>fg", builtin.live_grep,   desc = "Live Grep" },
        { "<leader>ff", builtin.find_files,  desc = "Find Files" },
        { "<leader>fr", builtin.oldfiles,    desc = "Old Files" },
        { "<leader>fs", builtin.grep_string, desc = "Grep String" },
      }
    end,
    opts = function()
      local actions = require("telescope.actions")

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
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
}
