# Neovim configuration

This is my personal Neovim configuration. It is a work in progress and I am constantly tweaking it.

## Installation

Clone the repository and install the plugins:

```sh
git clone git@github.com:tiesen243/dotfiles ~/.config/tiesen243/dotfiles
```

Open Neovim with this config:

```sh
NVIM_APPNAME=tiesen243/dotfiles/nvim nvim
```

## Plugins

### ai

+ [CopilotC-Nvim/CopilotChat.nvim](https://dotfyle.com/plugins/CopilotC-Nvim/CopilotChat.nvim)

### bars-and-lines

+ [SmiteshP/nvim-navic](https://dotfyle.com/plugins/SmiteshP/nvim-navic)

### color

+ [xiyaowong/transparent.nvim](https://dotfyle.com/plugins/xiyaowong/transparent.nvim)

### colorscheme

+ [EdenEast/nightfox.nvim](https://dotfyle.com/plugins/EdenEast/nightfox.nvim)

### completion

+ [zbirenbaum/copilot.lua](https://dotfyle.com/plugins/zbirenbaum/copilot.lua)

### editing-support

+ [folke/snacks.nvim](https://dotfyle.com/plugins/folke/snacks.nvim)
+ [windwp/nvim-ts-autotag](https://dotfyle.com/plugins/windwp/nvim-ts-autotag)
+ [windwp/nvim-autopairs](https://dotfyle.com/plugins/windwp/nvim-autopairs)

### file-explorer

+ [nvim-neo-tree/neo-tree.nvim](https://dotfyle.com/plugins/nvim-neo-tree/neo-tree.nvim)

### formatting

+ [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### git

+ [lewis6991/gitsigns.nvim](https://dotfyle.com/plugins/lewis6991/gitsigns.nvim)

### icon

+ [nvim-tree/nvim-web-devicons](https://dotfyle.com/plugins/nvim-tree/nvim-web-devicons)

### keybinding

+ [folke/which-key.nvim](https://dotfyle.com/plugins/folke/which-key.nvim)

### lsp

+ [mfussenegger/nvim-jdtls](https://dotfyle.com/plugins/mfussenegger/nvim-jdtls)
+ [rachartier/tiny-inline-diagnostic.nvim](https://dotfyle.com/plugins/rachartier/tiny-inline-diagnostic.nvim)
+ [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)

### lsp-installer

+ [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)

### markdown-and-latex

+ [MeanderingProgrammer/render-markdown.nvim](https://dotfyle.com/plugins/MeanderingProgrammer/render-markdown.nvim)

### nvim-dev

+ [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
+ [MunifTanjim/nui.nvim](https://dotfyle.com/plugins/MunifTanjim/nui.nvim)

### plugin-manager

+ [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### preconfigured

+ [LazyVim/LazyVim](https://dotfyle.com/plugins/LazyVim/LazyVim)

### snippet

+ [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)

### statusline

+ [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

+ [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)

## Shortcuts

### Navigation

| Shortcut | Mode | Description |
|----------|------|-------------|
| `j` / `<Down>` | n, v | Move down (respects wrap) |
| `k` / `<Up>` | n, v | Move up (respects wrap) |
| `<C-h>` | n | Go to left window |
| `<C-j>` | n | Go to lower window |
| `<C-k>` | n | Go to upper window |
| `<C-l>` | n | Go to right window |
| `<C-Up>` | n | Increase window height |
| `<C-Down>` | n | Decrease window height |
| `<C-Left>` | n | Decrease window width |
| `<C-Right>` | n | Increase window width |
| `[b` | n | Previous buffer |
| `]b` | n | Next buffer |

### LSP Navigation

| Shortcut | Mode | Description |
|----------|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | Go to references |
| `gi` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `]]` | n | Next reference |
| `[[` | n | Previous reference |

### Editing

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<A-j>` | n, i, v | Move line(s) down |
| `<A-k>` | n, i, v | Move line(s) up |
| `<` | n | Decrease indentation |
| `>` | n | Increase indentation |
| `<` | v | Decrease indentation (maintain selection) |
| `>` | v | Increase indentation (maintain selection) |
| `p` | v | Paste without yanking |
| `<C-s>` | n, i, v, s | Save file |
| `,` | i | Add undo break point |
| `.` | i | Add undo break point |
| `;` | i | Add undo break point |

### LSP Features

| Shortcut | Mode | Description |
|----------|------|-------------|
| `K` | n | Show hover documentation |
| `<C-k>` | i | Signature help |
| `<leader>ca` | n, v | Code action |
| `<leader>cd` | n | Show inline diagnostics |
| `<leader>cD` | n | Show workspace diagnostics |
| `<leader>cf` | n | Format |
| `<leader>cr` | n | Rename variable |
| `<leader>cR` | n | Rename file |
| `<leader>cs` | n | Document symbols |
| `<leader>ct` | n | Type definition |
| `<leader>cw` | n | Workspace symbols |

### Java-specific Keymaps

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>co` | n | Organize imports |
| `<leader>cxc` | n, v | Extract constant |
| `<leader>cxm` | v | Extract method |
| `<leader>cxv` | n, v | Extract variable |

### Buffer Management

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>bd` | n | Delete buffer |
| `<leader>bo` | n | Delete other buffers |
| `<leader>bD` | n | Delete buffer and window |

### Search and Diagnostics

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<Esc>` | i, n, s | Escape and clear search |
| `<leader>ur` | n | Redraw / clear hlsearch / diff update |
| `n` | n, v, o | Next search result |
| `N` | n, v, o | Previous search result |
| `]d` | n | Next diagnostic |
| `[d` | n | Previous diagnostic |
| `]e` | n | Next error |
| `[e` | n | Previous error |
| `]w` | n | Next warning |
| `[w` | n | Previous warning |

### Git Commands

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>gg` | n | Lazygit (root dir) |
| `<leader>gG` | n | Lazygit (cwd) |
| `<leader>gf` | n | Git current file history |
| `<leader>gb` | n | Git blame line |
| `<leader>gB` | n, v | Git browse (open) |
| `<leader>gY` | n, v | Git browse (copy URL) |

### UI Toggles

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>ua` | n | Toggle animations |
| `<leader>uA` | n | Toggle tabline |
| `<leader>ub` | n | Toggle dark background |
| `<leader>uc` | n | Toggle conceal level |
| `<leader>uC` | n | Change colorscheme |
| `<leader>ud` | n | Toggle diagnostics |
| `<leader>uD` | n | Toggle dim |
| `<leader>ug` | n | Toggle indent |
| `<leader>uh` | n | Toggle inlay hints |
| `<leader>ul` | n | Toggle line number |
| `<leader>uL` | n | Toggle relative numbers |
| `<leader>um` | n | Toggle markdown rendering |
| `<leader>us` | n | Toggle spelling |
| `<leader>uS` | n | Toggle smooth scroll |
| `<leader>ut` | n | Toggle transparency |
| `<leader>uT` | n | Toggle treesitter |
| `<leader>uw` | n | Toggle wrap |
| `<leader>ui` | n | Inspect position |
| `<leader>uI` | n | Inspect tree |
| `<leader>uZ` | n | Toggle window zoom |
| `<leader>uz` | n | Toggle zen mode |

### Terminal

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<C-/>` / `<C-_>` | n | Open terminal (root dir) |
| `<C-/>` / `<C-_>` | t | Hide terminal |

### Other

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>fG` | n | Find on Google |
| `gco` | n | Add comment below |
| `gcO` | n | Add comment above |
| `<leader>qq` | n | Quit |
| `<leader>qa` | n | Quit all |
| `<leader>qs` | n | Save and quit all |
| `<Tab>` | s | Jump to next snippet |
| `<S-Tab>` | i, s | Jump to previous snippet |

