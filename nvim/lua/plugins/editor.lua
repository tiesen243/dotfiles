return {
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
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
      icons = Yuki.icons.kinds,
      lsp = { auto_attach = true, preference = { "volar" } },
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
