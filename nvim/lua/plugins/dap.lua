vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

for name, sign in pairs(Yuki.configs.icons.dap) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

return {
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
  {
    { src = "https://github.com/thehamsta/nvim-dap-virtual-text" },
    opts = {
      enabled = true,
    },
  },

  {
    {
      name = "dap",
      src = "https://github.com/mfussenegger/nvim-dap",
    },
    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        { desc = "Breakpoint Condition" },
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        { desc = "Toggle Breakpoint" },
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        { desc = "Run/Continue" },
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        { desc = "Run to Cursor" },
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        { desc = "Go to Line (No Execute)" },
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        { desc = "Step Into" },
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        { desc = "Down" },
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        { desc = "Up" },
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        { desc = "Run Last" },
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        { desc = "Step Out" },
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        { desc = "Step Over" },
      },
      {
        "<leader>dP",
        function()
          require("dap").pause()
        end,
        { desc = "Pause" },
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        { desc = "Toggle REPL" },
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        { desc = "Session" },
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        { desc = "Terminate" },
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        { desc = "Widgets" },
      },
    },
  },

  {
    {
      name = "dap-python",
      src = "https://github.com/mfussenegger/nvim-dap-python",
    },
  },
}
