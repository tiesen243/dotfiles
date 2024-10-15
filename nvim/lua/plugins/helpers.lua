return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    lazy = false,
    keys = {
      { "<leader>f",  "<nop>",                           desc = "Telescope" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",    desc = "Live Grep" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",    desc = "Help Tags" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",   desc = "Find Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",     desc = "Recent Files" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
    },

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
      })

      telescope.load_extension("file_browser")
    end,
  },
  {
    "aserowy/tmux.nvim",
    lazy = false,
    keys = {
      { "<C-Up>",    "<cmd>lua require('tmux').resize_top()<cr>",    desc = "Increase Window Height" },
      { "<C-Left>",  "<cmd>lua require('tmux').resize_left()<cr>",   desc = "Decrease Window Width" },
     { "<C-Right>", "<cmd>lua require('tmux').resize_right()<cr>",  desc = "Increase Window Width" },
      { "<C-Down>",  "<cmd>lua require('tmux').resize_bottom()<cr>", desc = "Decrease Window Height" },
    },
    config = function()
      require("tmux").setup({
        resize = { enable_default_keybindings = false },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      local status_ok, wk = pcall(require, "which-key")
      if not status_ok then
        return
      end

      wk.setup({
        ---@type false | "classic" | "modern" | "helix"
        preset = "modern",

        triggers = { "<leader>", mode = { "n" } },

        win = {
          -- width = 1,
          -- height = { min = 4, max = 25 },
          -- col = 0,
          row = -1,
          border = "none",
          padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
          title = true,
          title_pos = "center",
          zindex = 1000,
          -- Additional vim.wo and vim.bo options
          bo = {},
          wo = {
            winblend = 1, -- value between 0-100 0 for fully opaque and 100 for fully transparent
          },
        },
        layout = {
          width = { min = 20 }, -- min and max width of the columns
          spacing = 4,          -- spacing between columns
          align = "center",     -- align columns left, center or right
        },
      })
    end
  },
  {
    "folke/noice.nvim",
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true,            -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
      })
    end
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,          -- #RGB hex codes
          RRGGBB = true,       -- #RRGGBB hex codes
          names = true,        -- "Name" codes like Blue or blue
          RRGGBBAA = true,     -- #RRGGBBAA hex codes
          AARRGGBB = true,     -- 0xAARRGGBB hex codes
          rgb_fn = true,       -- CSS rgb() and rgba() functions
          hsl_fn = true,       -- CSS hsl() and hsla() functions
          css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = true,                                -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = true,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      })
    end,
  },
}
