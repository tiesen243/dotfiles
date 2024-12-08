vim.g.copilot_no_tab_map = true

return {
  -- copilot
  {
    "github/copilot.vim",
    cmd = "Copilot",
    build = ":Copilot setup",
    lazy = false,
    keys = {
      {
        mode = { "i" },
        "<C-CR>",
        'copilot#Accept("\\<CR>")',
        desc = "Copilot Accept",
        expr = true,
        replace_keycodes = false,
      },
      { "<leader>gcp", "<cmd>Copilot panel<cr>", desc = "Panel" },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    build = "make tiktoken",
    keys = {
      { "<leader>gct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>gcr", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
      { "<leader>gcf", "<cmd>CopilotChatFix<cr>", desc = "Fix bug" },
      { "<leader>gco", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
      { "<leader>gcd", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Fix Diagnostic" },
      { "<leader>gcc", "<cmd>CopilotChatCommit<cr>", desc = "Suggest commit message" },
      { "<leader>gcs", "<cmd>CopilotChatCommitStaged<cr>", desc = "Suggest commit stage message" },
    },
    opts = {
      window = { title = "Copilot Chat", layout = "vertical", width = 0.4 },
    },
  },
}
