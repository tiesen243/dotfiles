return {
  -- Github Copilot
  -- https://github.com/zbirenbaum/copilot.lua
  {
    "github/copilot.vim",
    lazy = false,
    enabled = Yuki.ai,
    cmd = "Copilot",
    keys = {
      { "<leader>as", "<cmd>Copilot panel<cr>", desc = "Suggestion Panel" },
      {
        "<C-CR>",
        'copilot#Accept("\\<CR>")',
        expr = true,
        replace_keycodes = false,
        mode = { "i" }
      }
    },
  },

  -- Copilot Chat
  -- https://github.com/CopilotC-Nvim/CopilotChat.nvim
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    enabled = Yuki.ai,
    cmd = "CopilotChat",
    keys = function()
      local chat = require("CopilotChat")

      return {
        { "<leader>aa", chat.toggle, desc = "Toggle (CopilotChat)", mode = { "n", "v" } },
        { "<leader>ax", chat.reset,  desc = "Clear (CopilotChat)",  mode = { "n", "v" } },
        {
          "<leader>aq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end,
          desc = "Quick Chat (CopilotChat)",
          mode = { "n", "v" },
        },
        {
          "<leader>ap",
          function()
            local actions = require("CopilotChat.actions")
            actions.pick(actions.prompt_actions({ selection = require("CopilotChat.select").visual }))
          end,
          desc = "Prompt Actions (CopilotChat)",
          mode = { "n", "v" },
        },
      }
    end,
    opts = {
      window = { title = "Copilot Chat", layout = "vertical", width = 0.4 },
      auto_insert_mode = true,
      question_header = " " .. (vim.env.USER or "User") .. " ",
      answer_header = "  Copilot ",
    },
  },
}
