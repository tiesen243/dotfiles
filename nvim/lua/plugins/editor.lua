return {
  {
    "folke/which-key.nvim",
    opts = { preset = "moderm", win = { border = "rounded" } },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
 ╚████╔╝ ██║   ██║█████╔╝ ██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║
   ██║   ╚██████╔╝██║  ██╗██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
          ]],
        },
      },
    },
  },
}
