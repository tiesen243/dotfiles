return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          disabled_filetypes = { "alpha", "NvimTree", "dashboard" },
        },
        sections = { lualine_a = { { "filename", path = 1 } } },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },
    },
    config = function()
      local status_ok, nvim_tree = pcall(require, "nvim-tree")
      if not status_ok then
        return
      end

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true

      nvim_tree.setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = {
          enable = true,
          dotfiles = false,
          git_ignored = true,
          custom = { ".git" },
          exclude = { ".env", ".env*.local" },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    keys = {
      { "<Tab>",      "<cmd>BufferLineCycleNext<cr>",  desc = "Next tab" },
      { "<S-Tab>",    "<cmd>BufferLineCyclePrev<cr>",  desc = "Prev tab" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>",       desc = "Pick tab" },
      { "<leader>b",  "<nop>",                         desc = "Bufferline" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",  desc = "Close Left" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close Right" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>",  desc = "Pick & Close tab" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          max_name_length = 15,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "center",
            },
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("yuki_disable_miniindentscope", { clear = true }),
        pattern = { "help", "alpha", "dashboard", "NvimTree", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup()
    end,
  },
  { "MunifTanjim/nui.nvim" },
  {
    "goolord/alpha-nvim",
    config = function()
      local dashboard = require("alpha.themes.dashboard")

      -- Header --
      dashboard.section.header.val = {
        [[                                              ]],
        [[                                              ]],
        [[█████████╗██╗███████╗██████╗███████╗███╗   ██╗]],
        [[ ╚══██╔══╝██║██╔════╝██╔═══╝██╔════╝████╗  ██║]],
        [[    ██║   ██║█████╗  ██████╗█████╗  ██╔██╗ ██║]],
        [[    ██║   ██║██╔══╝  ╚═══██║██╔══╝  ██║╚██╗██║]],
        [[    ██║   ██║███████╗██████║███████╗██║ ╚████║]],
        [[    ╚═╝   ╚═╝╚══════╝╚═════╝╚══════╝╚═╝  ╚═══╝]],
        [[                                              ]],
        [[                    @tiesen243                ]],
      }

      -- Buttons --
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New file", "<cmd>enew<CR>"),
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("w", "󰈬  Find word", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "⏻  Quit", "<cmd>wqa<CR>"),
      }
      dashboard.section.buttons.opts = {
        spacing = 0,
        position = "center",
      }

      -- Footer --
      dashboard.section.footer.val = {
        [[                                              ]],
        [[                                              ]],
        [[                  I believe this world is flat]],
        [[                          Cuz loli is my world]],
        [[                                              ]],
        [[                                   Yukikaze <4]],
      }

      -- Configuration --
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.opts.opts.noautocmd = true

      -- Set up
      require("alpha").setup(dashboard.opts)
    end,
  },
}
