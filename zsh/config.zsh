export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

# Plugins
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# FZF Theme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
alias fzf="fzf -e"

# Alias

# General
alias  cls="clear"
alias   py="python"
alias   lg="lazygit"
alias   ls="lsd -l"
alias   la="lsd -a"
alias   lla="lsd -la"
alias   lt="lsd --tree"
alias    v="nvim"
alias    y="yazi"
alias    q="exit"

# Kitty
alias icat="kitten icat"

# Conda
alias cee='conda env export | grep -v "^prefix: " > environment.yml'
alias cda="conda deactivate"
alias cel="conda env list"
alias cec="conda create -n"
alias cer="conda env remove -n"
alias  ci="conda install"
alias  cr="conda remove"
alias  ca="conda activate"

# Bun
alias  bup="bun upgrade"
alias  bad="bun add -d"
alias  bap="bun add -p"
alias   ba="bun add"
alias   bc="bun create"
alias   bi="bun install"
alias   bd="bun dev"
alias   bl="bun lint"
alias   bf="bun format"
alias   bb="bun run build"
alias   bs="bun start"
alias   bp="bun preview"
alias   bu="bun update"
alias   br="bun remove"
alias    b="bun"

# Git
alias   grc="gh repo create"
alias   gcd="gh repo delete"
alias   gcl="gh repo clone"
alias    gs="git status"

# Pacman (Arch Linux) | Yay
alias    pr="yay -Runs"
alias    pu="yay -Syu"
alias    pc="yay -Scc"
alias    pi="yay -S"

# Others
alias monitor="hyprctl monitors"
alias spec="clear && fastfetch -c ~/dotfiles/zsh/fastfetch.jsonc"

# Custom commands

gP () {
  git add .
  if [ -z "$1" ]; then
    git commit
  else
    git commit -m "$1"
  fi
  git push
}

vfzf () {
  nvim $(fzf -e)
}

cowsay -f moose $(date)
