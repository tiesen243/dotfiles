return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      treesitter.setup({
        auto_install = true,
        sync_install = true,
        indent = { enable = true },
        incremental_selection = { enable = true },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
      })

      vim.filetype.add({ extension = { mdx = "mdx", conf = "bash" } })
      vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

      vim.treesitter.language.register("markdown", "mdx")
    end
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "folke/todo-comments.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local status_ok, comment = pcall(require, "Comment")
      if not status_ok then
        return
      end

      local status_okk, ts_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if not status_okk then
        return
      end

      local status_okkk, todo = pcall(require, "todo-comments")
      if not status_okkk then
        return
      end

      vim.g.skip_ts_context_commentstring_module = true

      comment.setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "<C-/>",
          block = "<C-S-/>",
        },
        opleader = {
          line = "<C-/>",
          block = "<C-S-/>",
        },
        pre_hook = ts_commentstring.create_pre_hook(),
      })

      todo.setup()
    end
  },
  {
    "m4xshen/autoclose.nvim",
    config = function()
      require('autoclose').setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require('nvim-autopairs').setup()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
