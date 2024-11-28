return {
  -- Basics config
  {
    "echasnovski/mini.basics",
    opts = {
      -- Options. Set to `false` to disable.
      options = {
        -- Basic options ('number', 'ignorecase', and many more)
        basic = true,
        -- Extra UI features ('winblend', 'cmdheight=0', ...)
        extra_ui = false,
        -- Presets for window borders ('single', 'double', ...)
        win_borders = "rounded",
      },
      -- Mappings. Set to `false` to disable.
      mappings = {
        -- Basic mappings (better 'jk', save with Ctrl+S, ...)
        basic = true,
        -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
        -- Supply empty string to not create these mappings.
        option_toggle_prefix = [[\]],
        -- Window navigation with <C-hjkl>, resize with <C-arrow>
        windows = true,
        -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
        move_with_alt = true,
      },
      -- Autocommands. Set to `false` to disable
      autocommands = {
        -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
        basic = true,
        -- Set 'relativenumber' only in linewise and blockwise Visual mode
        relnum_in_visual_mode = true,
      },
      silent = false,
    },
  },

  -- Icons
  {
    "echasnovski/mini.icons",
    init = function()
      require("mini.icons").mock_nvim_web_devicons()
    end,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        [".env"] = { glyph = "", hl = "MiniIconsYellow" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
  },

  -- Indentscope
  {
    "echasnovski/mini.indentscope",
    opts = { symbol = "▏", options = { try_as_border = true } },
  },

  -- Comment
  {
    "echasnovski/mini.comment",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
    },
    opts = {
      options = {
        ignore_blank_line = true,
        start_of_line = true,
        pad_comment_parts = true,
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
      mappings = {
        comment = "<C-/>",
        comment_line = "<C-/>",
        comment_visual = "<C-/>",
        textobject = "<C-/>",
      },
    },
  },
}
