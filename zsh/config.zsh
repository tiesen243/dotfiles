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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-commit gitignore sudo vi-mode z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#############################################
# Alias
# This is a list of custom aliases that I usually use.
#############################################

# General
alias c="clear"
alias v="nvim"
alias q="exit"

# Directory
alias xh="cd $HOME"
alias xd="cd $HOME/Documents"
alias xD="cd $HOME/Downloads"
alias xp="cd $HOME/Pictures"
alias xc="cd $HOME/dotfiles"

# Kitty
alias icat="kitten icat"

# LSD
alias ls="lsd"
alias lt="lsd --tree --depth 3"

# Bun
alias bff="bun format:fix"
alias blf="bun lint:fix"
alias bf="bun format"
alias bl="bun lint"
alias ba="bun add"
alias bi="bun install"
alias bu="bun update"
alias br="bun remove"
alias bx="bunx --bun"
alias bb="bun run build"
alias bs="bun start"
alias bd="bun dev"
alias b="bun"

# Git
alias grc="gh repo create"
alias grd="gh repo delete"
alias gcl="gh repo clone"

# Pacman | Yay
alias yp="yay -Qdtq | yay -Rns -"
alias yr="yay -Runs"
alias yu="yay -Syu"
alias yc="yay -Scc"
alias yi="yay -S"

#############################################
# Functions
#############################################

# FZF + Neovim with kitten icat for images
vf() {
  local file
  file=$(fzf \
    --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [ -n "$file" ]; then
    nvim "$file"
  fi
}

vh() {
  local file
  file=$(find $HOME -type f \
    -not -path '*/\.*' -o -path '*/.config/*' |
    fzf \
      --preview 'bat --style=numbers --color=always --line-range :500 {}' \
      --preview-window=right:60% \
      --border \
      --height=80%)
  if [ -n "$file" ]; then
    nvim "$file"
  fi
}

#############################################
# Add custom bin directory to PATH
# If you don't use this, you can remove this block.
#############################################

# >>> nvm initialize >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# <<< nvm initialize <<<

# >>> bun initialize >>>
if [ -d "$HOME/.bun/bin" ]; then
  export PATH="$HOME/.bun/bin:$PATH"

  if [[ ! -f "$ZSH_CACHE_DIR/completions/_bun" ]]; then
    typeset -g -A _comps
    autoload -Uz _bun
    _comps[bun]=_bun
  fi

  SHELL=zsh bun completions >| "$ZSH_CACHE_DIR/completions/_bun" &|
fi
# <<< bun initialize <<<

# >>> uv initialize >>>
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"
# <<< uv initialize <<<
