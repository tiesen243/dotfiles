#############################################
# Environment variables
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#############################################

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST


#############################################
# ZSH Plugins and Theme
#############################################

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="yuki"
# Tokyo Night theme for fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)


source $ZSH/oh-my-zsh.sh


#############################################
# Alias
# This is a list of custom aliases that I usually use.
#############################################

# General
alias  cls="clear"
alias    v="nvim"
alias    q="exit"

# Directory
alias   xh="cd $HOME"
alias   xd="cd $HOME/Documents"
alias   xD="cd $HOME/Downloads"
alias   xp="cd $HOME/Pictures"
alias   xc="cd $HOME/dotfiles"

# Kitty
alias icat="kitten icat"

# LSD
alias   ls="lsd"
alias   lt="lsd --tree --depth 3"

# Bun
alias  bff="bun format:fix"
alias   bf="bun format"
alias  blf="bun lint:fix"
alias   bl="bun lint"
alias   ba="bun add"
alias   bu="bun update"
alias   br="bun remove"
alias   bx="bunx --bun"
alias   bb="bun run build"
alias   bs="bun start"
alias   bd="bun dev"
alias    b="bun"

# Git
alias  grc="gh repo create"
alias  grd="gh repo delete"
alias  gcl="gh repo clone"

# Pacman | Yay
alias yp="yay -Qdtq | yay -Rns -"
alias yr="yay -Runs"
alias yu="yay -Syu"
alias yc="yay -Scc"
alias yi="yay -S"


#############################################
# Functions
#############################################

gacp()
{
  git add --all
  if [ -z "$1" ]; then
    git cz -a
  else
    git commit -a -m "$1"
  fi
  git push origin
}


#############################################
# Add custom bin directory to PATH
# If you don't use this, you can remove this block.
#############################################

# >>> nvm initialize >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# <<< nvm initialize <<<

# >>> bun initialize >>>
if [ -d "$HOME/.bun/bin" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
fi
# <<< bun initialize <<<

# >>> uv initialize >>>
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"
# <<< uv initialize <<<

