-- Leader key (default is space)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

_G.Yuki = {
  colorcheme = 'tokyonight',
  coding = {
    format_on_save = true,
    lang = {
      java = false,
      python = false,
      react = true,
      vue = true,
    },
    use_copilot = true,
  },
  icons = {
    diagnostics = {
      Error = ' ',
      Warn = ' ',
      Hint = ' ',
      Info = ' ',
    },
    git = {
      added = ' ',
      modified = ' ',
      removed = ' ',
    },
    git_signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    git_signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    kinds = {
      Array = ' ',
      Boolean = ' ',
      Class = ' ',
      Color = ' ',
      Control = ' ',
      Collapsed = ' ',
      Constant = ' ',
      Constructor = ' ',
      Copilot = ' ',
      Enum = ' ',
      EnumMember = ' ',
      Event = ' ',
      Field = ' ',
      File = ' ',
      Folder = ' ',
      Function = ' ',
      Interface = ' ',
      Key = ' ',
      Keyword = ' ',
      Method = ' ',
      Module = ' ',
      Namespace = ' ',
      Null = ' ',
      Number = '󰎠 ',
      Object = ' ',
      Operator = ' ',
      Package = ' ',
      Property = ' ',
      Reference = ' ',
      Snippet = '󱄽 ',
      String = ' ',
      Struct = ' ',
      Text = ' ',
      TypeParameter = ' ',
      Unit = ' ',
      Value = ' ',
      Variable = ' ',
    },
  },
  logo = [[
██╗   ██╗██╗   ██╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
 ╚████╔╝ ██║   ██║█████╔╝ ██║
  ╚██╔╝  ██║   ██║██╔═██╗ ██║
   ██║   ╚██████╔╝██║  ██╗██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
   ]],
}
