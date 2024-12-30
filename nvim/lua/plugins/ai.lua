return {
  -- Copilot
  -- https://github.com/github/copilot.vim
  {
    "github/copilot.vim",
    cmd = "Copilot",
    build = ":Copilot setup",
    lazy = false,
    keys = {
      { "<leader>gcp", "<cmd>Copilot panel<cr>", desc = "Panel" },
    },
  },

  -- Copilot Chat (requires Copilot)
  -- https://github.com/CopilotC-Nvim/CopilotChat.nvim
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    build = "make tiktoken",
    keys = {
      { "<leader>gcc", "<cmd>CopilotChatCommit<cr>",   desc = "Suggest commit message" },
      { "<leader>gcd", "<cmd>CopilotChatDocs<cr>",     desc = "Suggest documentation" },
      { "<leader>gcf", "<cmd>CopilotChatFix<cr>",      desc = "Fix bug" },
      { "<leader>gco", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
      { "<leader>gcr", "<cmd>CopilotChatReview<cr>",   desc = "Review code" },
      { "<leader>gct", "<cmd>CopilotChatToggle<cr>",   desc = "Toggle Copilot Chat" },
      { "<leader>gcT", "<cmd>CopilotChatTests<cr>",    desc = "Test code" },
    },
    opts = {
      window = { title = "Copilot Chat", layout = "vertical", width = 0.4 },
    },
  },
}
