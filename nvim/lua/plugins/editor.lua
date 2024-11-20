return {
  -- Github theme
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = { transparent = vim.g.transparent_enabled },
  },
  {
    "xiyaowong/transparent.nvim",
    opts = function()
      require("transparent").clear_prefix("NvimTree")
      return { exclude_groups = { "CursorLine" } }
    end,
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },
    },

    opts = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true

      return {
        update_cwd = true,
        view = { width = 32 },
        diagnostics = { enable = true },
        renderer = { group_empty = true },
        sort = { sorter = "case_sensitive" },
        filters = {
          enable = true,
          dotfiles = false,
          git_ignored = true,
          custom = { ".git$" },
          exclude = { ".env" },
        },
      }
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        disabled_filetypes = { statusline = { "snacks_dashboard", "NvimTree" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          { "branch" },
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

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      require("which-key").add({
        { "<leader>a", group = "Actions", icon = { icon = " ", color = "yellow" } },
        { "<leader>b", group = "Buffers" },
        { "<leader>f", group = "Telescope" },
        { "<leader>g", group = "Git" },
        { "<leader>gc", group = "Copilot" },
        { "<leader>l", group = "LSP", icon = { icon = " ", color = "green" } },
        { "<leader>o", group = "Options", icon = { icon = " ", color = "blue" } },
      })

      return {
        ---@type false | "classic" | "modern" | "helix"
        preset = "modern",

        triggers = { "<leader>", mode = { "n" } },

        win = {
          title = false,
          zindex = 1000,
          ---@type "none" | "single" | "double" | "rounded"
          border = "rounded",
          padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        },
        layout = {
          width = { min = 20 }, -- min and max width of the columns
          spacing = 4, -- spacing between columns
          align = "center", -- align columns left, center or right
        },
      }
    end,
  },

  -- telescope is a highly extendable fuzzy finder over lists.
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
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
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = { find_files = { theme = "dropdown" } },
        extensions = { file_browser = { theme = "dropdown" } },
      })

      telescope.load_extension("file_browser")
    end,
  },
  {
    "aserowy/tmux.nvim",
    opts = { resize = { enable_default_keybindings = false } },
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

  -- ui components
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

      words = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      styles = { notification = { wo = { wrap = true } } },
    },
  },
}
