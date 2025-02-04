if not Yuki.configs.lang.prisma then
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
