#############################################
# Environment variables
#############################################
export ZSH="$HOME/.oh-my-zsh"
export YAZI_CONFIG_HOME="$HOME/dotfiles/yazi"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

#############################################
# ZSH Plugins and Theme
#############################################
ZSH_THEME="yuki"
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

#############################################
# Alias
# This is a list of custom aliases that I usually use.
#############################################

# General
alias date="date +'%A %d-%m-%Y %H:%M:%S'"
alias  lla="lsd -la"
alias  fzf="fzf -e"
alias  cls="clear"
alias  cat="bat"
alias   lt="lsd --tree --depth=3"
alias   lg="lazygit"
alias   ls="lsd -l"
alias   la="lsd -a"
alias   py="python"
alias    v="nvim"
alias    q="exit"

# Kitty
alias icat="kitten icat"

# Conda
# alias  cee="conda env export | grep -v '^prefix: ' > environment.yml"
# alias  cer="conda env remove -n"
# alias  ced="conda deactivate"
# alias  cec="conda create -n"
# alias  cel="conda env list"
# alias   ca="conda activate"
# alias   ci="conda install"
# alias   cr="conda remove"

# Bun
alias  bup="bun upgrade"
alias  big="bun install -g"
alias  bug="bun update -g"
alias  bad="bun add -d"
alias  bap="bun add -p"
alias  bff="bun format:fix"
alias  blf="bun lint:fix"
alias   bb="bun run build"
alias   bo="bun outdated"
alias   bp="bun preview"
alias   bi="bun install"
alias   bx="bunx --bun"
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
alias  gcs="gh copilot suggest"
alias  gce="gh copilot explain"
alias  grv="gh repo view --web"
alias  gpf="git push --force"
alias  grc="gh repo create"
alias  grd="gh repo delete"
alias  gcl="gh repo clone"
alias  gaa="git add --all"
alias  gcz="git cz --all"
alias   gp="git push origin"
alias   gc="git commit -a"
alias   gS="git switch"
alias   gs="git status"
alias   gl="git pull"
alias   ga="git add"
alias    g="git"

# Docker
alias  ddc="docker rm -f $(docker ps -a -q)"
alias  ddi="docker rmi -f $(docker images -q)"
alias   dc="docker container ls"
alias   di="docker images"
alias   db="docker build"
alias   dr="docker run"

# Pacman (Arch Linux) | Yay
alias pacq="yay -Qdtq | yay -Rns -"
alias pacr="yay -Runs"
alias pacu="yay -Syu"
alias pacc="yay -Scc"
alias paci="yay -S"

#############################################
# Functions
#############################################

gP () {
  git add .
  if [ -z "$1" ]; then
    git commit -a
  else
    git commit -a -m "$1"
  fi
  git push
}


#############################################
# Add custom bin directory to PATH
# If you don't use this, you can remove this block.
#############################################

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/tiesen/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/tiesen/.miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/tiesen/.miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/tiesen/.miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

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
