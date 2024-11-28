return {
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = { markdown = true, help = true },
    },
  },

  { "zbirenbaum/copilot-cmp", opts = {} },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    keys = {
      { "<leader>gct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>gce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
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
