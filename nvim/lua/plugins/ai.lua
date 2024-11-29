return {
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = function()
      Snacks.toggle({
        name = "AI Completion",
        get = function()
          return vim.g.ai_cmp
        end,
        set = function(state)
          if state then
            vim.g.ai_cmp = true
          else
            vim.g.ai_cmp = false
          end
        end,
      }):map("<leader>ci")

      return {
        panel = { enabled = false },
        suggestion = { enabled = vim.g.ai_cmp },
        filetypes = { markdown = true, help = true },
      }
    end,
  },

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
