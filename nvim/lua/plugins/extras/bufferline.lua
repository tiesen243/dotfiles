return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    lazy = false,
    keys = {
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
      { "<leader>bP", "<cmd>BufferLinePickClose<cr>", desc = "Pick Close Buffer" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Left Buffers" },
      { "<leader>bh", "<cmd>BufferLineCloseRight<cr>", desc = "Close Right Buffers" },
    },
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
}
