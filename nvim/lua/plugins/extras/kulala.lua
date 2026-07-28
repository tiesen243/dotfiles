return {
  {
    {
      src = "https://github.com/mistweaverco/kulala.nvim",
    },
    opts = {
      global_keymaps = false,
    },
    keys = {
      {
        "<CR>",
        function()
          require("kulala").run()
        end,
        { desc = "Send request", ft = "http", mode = { "n", "v" } },
      },
    },
  },
}
