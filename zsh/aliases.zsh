# ------------       General        ------------
alias icon="kitten unicode-input"
alias icat="kitten icat"
alias cls="clear"
alias q="exit"
alias v="nvim"

# ------------    Pacman / Yay      ------------
if (( $+commands[yay] )); then
  alias y='yay'
  alias yu='yay -Syu'
  alias ys='yay -Ss'
  alias yi='yay -S'
  alias yr='yay -Rns'
  alias yc='yay -Yc'
else
  alias y='sudo pacman'
  alias yu='sudo pacman -Syu'
  alias ys='pacman -Ss'
  alias yi='sudo pacman -S'
  alias yr='sudo pacman -Rns'
  alias yc='sudo pacman -Rns $(pacman -Qtdq)'
fi

alias yq='pacman -Qi'
alias yl='pacman -Ql'

# ------------          LS          ------------
if (( $+commands[lsd] )); then
  alias ls='lsd'
  
  alias lld='lsd -l --directory-only'
  alias lt='lsd --tree --depth 3'
  alias lla='lsd -la'
  alias la='lsd -a'
  alias l='lsd -l'
else
  alias l='ls -lh'
  alias la='ls -A'
  alias lla='ls -lah'
fi

# ------------        Git           ------------
if (( $+commands[git] )); then
  alias g='git'
  
  # Xem trạng thái & Lịch sử
  alias gs='git status -sb'
  alias gl='git log --oneline --graph --decorate'
  alias gd='git diff'
  
  # Thêm và Commit
  alias ga='git add'
  alias gaa='git add --all'
  alias gc='git commit -m'
  alias gca='git commit --amend'
  
  alias gsw='git switch'
  alias gsc='git switch -c'
  alias gsm='git switch main'
  alias gsd='git switch dev'
  alias gswb='git switch -'
  
  alias grs='git restore'
  alias grss='git restore --staged'
  
  alias gp='git push'
  alias gpf='git push --force-with-lease'
  alias gpl='git pull'
  alias gf='git fetch'
  
  alias gst='git stash'
  alias gstp='git stash pop'
fi

if (( $+commands[lazygit] )); then
  alias lg='lazygit'
fi

# ------------         Bun          ------------
if (( $+commands[bun] )); then
  alias bi='bun install'
  alias ba='bun add'
  alias bad='bun add -d'
  alias brm='bun remove'
  alias bu='bun update'
  alias bur='bun update --interactive --recursive'

  alias bx='bunx --bun'
  alias bd='bun --bun run dev'
  alias bb='bun --bun run build'
  alias br='bun --bun run'

  alias b='bun'
  alias bw='bun --hot'
  alias btest='bun test'
fi
