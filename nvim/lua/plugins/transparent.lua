return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  init = function()
    require("transparent").clear_prefix("NeoTree")
    require("transparent").clear_prefix("WhichKey")
  end,
  opts = {
    extra_groups = { "NormalFloat" },
    exclude_groups = { "CursorLine" },
  },
}
