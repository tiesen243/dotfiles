return {
  -- file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = { "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Snacks.git.get_root() })
        end,
        desc = "File Explorer (rwd)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "File Explorer (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
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
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["l"] = "open",
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
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
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
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED,   handler = on_move },
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

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        { "<leader>fd",       builtin.diagnostics, desc = "[F]ind [D]iagnostics" },
        { "<leader>ff",       builtin.find_files,  desc = "[F]ind [F]iles" },
        { "<leader>fg",       builtin.live_grep,   desc = "[F]ind by [G]rep" },
        { "<leader>fh",       builtin.help_tags,   desc = "[F]ind [H]elp" },
        { "<leader>fk",       builtin.keymaps,     desc = "[F]ind [K]eymaps" },
        { "<leader>fr",       builtin.oldfiles,    desc = "[F]ind [R]ecents File" },
        { "<leader>fs",       builtin.builtin,     desc = "[F]ind [S]elect Telescope" },
        { "<leader>fw",       builtin.grep_string, desc = "[F]ind by current [W]ord" },
        { "<leader><leader>", builtin.buffers,     desc = "Find existing buffers" },
        {
          "<leader>/",
          function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
          end,
          desc = "Fuzzily search in current buffer",
        },
      }
    end,
    opts = function()
      local actions = require("telescope.actions")

      local function find_command()
        if 1 == vim.fn.executable("rg") then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable("where") then
          return { "where", "/r", ".", "*" }
        end
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = { find_files = { find_command = find_command, hidden = true } },
        live_grep = { additional_args = { "--hidden" } },
      }
    end,
  },

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>q", group = "quit/session" },
          { "<leader>u", group = "ui" },
          { "[",         group = "prev" },
          { "]",         group = "next" },
          { "g",         group = "goto" },
          { "z",         group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
  },

  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      Yuki.lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = {
      click = true,
      highlight = true,
      depth_limit = 5,
      lazy_update_context = true,
      icons = Yuki.icons.kinds,
      lsp = { preference = { "volar" } },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { preset = { header = Yuki.configs.logo } },
      explorer = { replace_netrw = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },

  -- Git Signs
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    keys = function()
      local gitsigns = require("gitsigns")
      return {
        { "<leader>gs", gitsigns.stage_hunk,      desc = "[G]it [s]tage Hunk" },
        { "<leader>gS", gitsigns.stage_buffer,    desc = "[G]it [S]tage Buffer" },
        { "<leader>gr", gitsigns.reset_hunk,      desc = "[G]it [r]eset Hunk" },
        { "<leader>gR", gitsigns.reset_buffer,    desc = "[G]it [R]eset Buffer" },
        { "<leader>gu", gitsigns.undo_stage_hunk, desc = "[G]it [U]ndo Stage Hunk" },
        { "<leader>gp", gitsigns.preview_hunk,    desc = "[G]it [P]review Hunk" },
        { "<leader>gd", gitsigns.diffthis,        desc = "[G]it [D]iff against index" },
      }
    end,
    opts = {
      current_line_blame = true,
      signs = Yuki.icons.git_signs,
      signs_staged = Yuki.icons.git_signs_staged,
      current_line_blame_opts = { delay = 500, ignore_whitespace = true },
    },
  },
}
