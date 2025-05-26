# General
alias rmf="rm -rf"
alias cls="clear"
alias v="nvim"
alias q="exit"

# Kitty
alias icat="kitten icat"

# LSD
alias ls="lsd"
alias lt="ls --tree --depth 3"

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
alias lzg="lazygit"
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
alias gl="git log --all --graph --decorate --pretty=format:'%C(magenta)%h %C(white) %an - %ar%C(auto) %D%n%s%n'"
alias g="git"

alias gsw="git switch"
alias gp="git push"
alias gu="git pull"

alias gap="git add --patch"
alias gaa="git add ."
alias ga="git add"
alias gc="git commit -a"
alias gs="git status"

# Pacman | Yay
alias yp="yay -Qdtq | yay -Rns -"
alias yr="yay -Runs"
alias yu="yay -Syu"
alias yc="yay -Scc"
alias yi="yay -S"
