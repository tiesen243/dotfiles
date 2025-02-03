if not Yuki.coding.lang.typescript or not Yuki.coding.lang.vue then
  return {}
end

return {

  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      prismals = {},
    },
  },
}
