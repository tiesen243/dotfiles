export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

# Plugins
plugins=(git emoji zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# FZF Theme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
alias fzf="fzf -e"

# Alias

alias q="exit"
alias vi="nvim"
alias py="python"
alias lg="lazygit"
alias cls="clear"
alias monitor="hyprctl monitors"
alias battery="cat /sys/class/power_supply/BAT1/capacity"
alias fetch="fastfetch --logo ~/dotfiles/YukikazeWedding.png"

# Kitty
alias icat="kitten icat"

# Conda
alias ci="conda install"
alias cr="conda remove"
alias ca="conda activate"
alias cda="conda deactivate"
alias cenvl="conda env list"
alias cenvc="conda create -n"
alias cenvr="conda env remove -n"
alias cenvle='conda env export | grep -v "^prefix: " > environment.yml'

# Bun
alias b="bun"
alias bc="bun create"
alias bi="bun install"
alias ba="bun add"
alias bad="bun add -d"
alias bup="bun add -p"
alias br="bun remove"
alias bu="bun update"
alias bf="bun format"
alias bl="bun lint"
alias bd="bun dev"
alias bb="bun run build"
alias bst="bun start"

# Custom commands

gitpush () {
  git add .
  git commit -m "$1"
  git push
}

vfzf () {
  nvim $(fzf -e)
}


date
