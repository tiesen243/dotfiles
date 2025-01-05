return {
  -- Keymap hint
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "AI" },
          { "<leader>b", group = "Buffers" },
          { "<leader>c", group = "Code" },
          { "<leader>f", group = "Finder" },
          { "<leader>g", group = "Git" },
          { "<leader>q", group = "Quit" },
          { "<leader>t", group = "Terminal" },
          { "<leader>u", group = "UI" },
          { "<leader>w", group = "Window" },
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
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Snacks.git.get_root() })
        end,
        desc = "Explorer NeoTree (rwd)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
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
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = { bind_to_cwd = false, follow_current_file = { enabled = true }, use_libuv_file_watcher = true },
      window = {
        width = 32,
        position = "left",
        mappings = {
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          git_status = {
            symbols = {
              unstaged = "󰄱",
              staged = "󰱒",
            },
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
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
        { "<leader>fd", builtin.diagnostics, desc = "[F]ind [D]iagnostics" },
        { "<leader>ff", builtin.find_files, desc = "[F]ind [F]iles" },
        { "<leader>fg", builtin.live_grep, desc = "[F]ind by [G]rep" },
        { "<leader>fh", builtin.help_tags, desc = "[F]ind [H]elp" },
        { "<leader>fk", builtin.keymaps, desc = "[F]ind [K]eymaps" },
        { "<leader>fr", builtin.oldfiles, desc = "[F]ind [R]ecents File" },
        { "<leader>fs", builtin.builtin, desc = "[F]ind [S]elect Telescope" },
        { "<leader>fw", builtin.grep_string, desc = "[F]ind by current [W]ord" },
        {
          "<leader>/",
          function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
          end,
          desc = "Search in current buffer",
        },
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
        pickers = { find_files = { file_ignore_patterns = { "node_modules", ".git", ".venv" }, hidden = true } },
        live_grep = { file_ignore_patterns = { "node_modules", ".git", ".venv" }, additional_args = { "--hidden" } },
      }
    end,
  },

  -- Git Signs
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      signs = Yuki.icons.git_signs,
      signs_staged = Yuki.icons.git_signs_staged,
      current_line_blame_opts = { delay = 500, ignore_whitespace = true },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = { preset = { header = Yuki.logo } },
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
