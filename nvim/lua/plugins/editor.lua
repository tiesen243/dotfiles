return {
  -- file explorer
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = { "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
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
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
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
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
        {
          event = "file_open_requested",
          handler = function()
            vim.cmd("Neotree close")
          end,
        },
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

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  -- https://github.com/folke/which-key.nvim
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
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "z", group = "fold" },
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

  -- code context
  -- https://github.com/SmiteshP/nvim-navic
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
      icons = Yuki.configs.icons.kinds,
      lsp = { auto_attach = true },
      highlight = true,
      separator = "  ",
      depth_limit = 3,
      lazy_update_context = true,
      click = true,
    },
  },

  -- QoL plugins for neovim.
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- stylua: ignore start
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find by Grep" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Find Help" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find Keymaps" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find Recents File" },
      { "<leader>fs", function() Snacks.picker() end, desc = "Select Picker" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Find by current [W]ord" },
      { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Opening buffers" },
      { "<leader>/", function() Snacks.picker.grep_buffers() end, desc = "Fuzzily search in current buffer" },
      -- stylua: ignore end
    },

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

  -- integration for git
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    keys = function()
      local gitsigns = require("gitsigns")
      return {
        { "<leader>gs", gitsigns.stage_hunk, desc = "[G]it [s]tage Hunk" },
        { "<leader>gS", gitsigns.stage_buffer, desc = "[G]it [S]tage Buffer" },
        { "<leader>gr", gitsigns.reset_hunk, desc = "[G]it [r]eset Hunk" },
        { "<leader>gR", gitsigns.reset_buffer, desc = "[G]it [R]eset Buffer" },
        { "<leader>gu", gitsigns.undo_stage_hunk, desc = "[G]it [U]ndo Stage Hunk" },
        { "<leader>gp", gitsigns.preview_hunk, desc = "[G]it [P]review Hunk" },
        { "<leader>gd", gitsigns.diffthis, desc = "[G]it [D]iff against index" },
      }
    end,
    opts = {
      current_line_blame = true,
      signs = Yuki.configs.icons.git_signs,
      signs_staged = Yuki.configs.icons.git_signs_staged,
      current_line_blame_opts = { delay = 500, ignore_whitespace = true },
    },
  },
}
