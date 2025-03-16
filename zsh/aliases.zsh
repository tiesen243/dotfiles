# General
alias cls="clear"
alias v="nvim"
alias q="exit"

# Kitty
alias icat="kitten icat"

# LSD
alias ls="lsd --date=relative --group-dirs=first --hyperlink always --total-size --size short"
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

# Pacman | Yay
alias yp="yay -Qdtq | yay -Rns -"
alias yr="yay -Runs"
alias yu="yay -Syu"
alias yc="yay -Scc"
alias yi="yay -S"
