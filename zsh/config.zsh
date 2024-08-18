# Environment variables
export ZSH="$HOME/.oh-my-zsh"
export YAZI_CONFIG_HOME="$HOME/dotfiles/yazi"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# ZSH Plugins and Theme
ZSH_THEME="yuki"
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

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
alias  cee='conda env export | grep -v "^prefix: " > environment.yml'
alias  cer="conda env remove -n"
alias  cda="conda deactivate"
alias  cec="conda create -n"
alias  cel="conda env list"
alias   ca="conda activate"
alias   ci="conda install"
alias   cr="conda remove"

# Bun
alias  bup="bun upgrade"
alias  bad="bun add -d"
alias  bap="bun add -p"
alias   bb="bun run build"
alias   bp="bun preview"
alias   bi="bun install"
alias   bc="bun create"
alias   bu="bun update"
alias   br="bun remove"
alias   bf="bun format"
alias   bs="bun start"
alias   bl="bun lint"
alias   ba="bun add"
alias   bd="bun dev"
alias    b="bun"

# Git
alias  gpf="git push --force"
alias  grc="gh repo create"
alias  grd="gh repo delete"
alias  gcl="gh repo clone"
alias   gs="git status"

# Pacman (Arch Linux) | Yay
alias pacq="yay -Qdtq | yay -Rns -"
alias pacr="yay -Runs"
alias pacu="yay -Syu"
alias pacc="yay -Scc"
alias paci="yay -S"

# Others
alias moni="hyprctl monitors"
alias spec="clear && fastfetch -c ~/dotfiles/fastfetch/config.jsonc"
alias  fzf="fzf -e"
alias  cat="bat"

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

