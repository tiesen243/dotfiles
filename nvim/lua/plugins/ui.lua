return {
  {
    "tiesen243/vercel.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vercel").setup({ theme = "dark", transparent = false })
      vim.cmd.colorscheme("vercel")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      highlights = function()
        local status_ok, vercel = pcall(require, "vercel")
        if not status_ok then
          return {}
        end
        return vercel.highlights.bufferline
      end,
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = " File Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        always_divide_middle = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "snacks_dashboard", "neo-tree" },
      },
      -- stylua: ignore start
      sections = {
        lualine_a = { { 'mode', fmt = function(str) return ' ' .. str end } },
        lualine_b = { "branch" },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          { "diagnostics", symbols = Yuki.icons.diagnostics },
        },
        lualine_x = {
          {
            "diff",
            symbols =  Yuki.icons.git,
            sources = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then return gitsigns end
            end,
          },
          { "selectioncount", padding = { left = 1, right = 1 } },
          { "searchcount", padding = { left = 1, right = 1 } },
        },
        lualine_y = {
          { "progress", separator = "" },
          { "location" },
        },
        lualine_z = { Yuki.utils.get_time }
      },
      -- stylua: ignore end
      inactive_sections = {},
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>q", group = "Quit" },
        { "<leader>u", group = "UI" },
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

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      signs = Yuki.icons.git_signs,
      signs_staged = Yuki.icons.git_signs_staged,
      current_line_blame_opts = { delay = 500, ignore_whitespace = true },
    },
  },
}
