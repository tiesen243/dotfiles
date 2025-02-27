# General
alias cls="clear"
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
alias ll="lsd -l"
alias la="lsd -la"
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
