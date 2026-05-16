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

  gc() {
    local types="(feat|fix|chore|docs|style|refactor|perf|test|ci)"
    
    if [[ -z "$1" || -z "$2" ]]; then
      echo "❌ Syntax error! Usage: gcm <type> <message>" >&2
      echo "Example: gcm chore update zsh config" >&2
      return 1
    fi

    if [[ ! "$1" =~ ^$types$ ]]; then
      echo "❌ Invalid commit type '$1'!" >&2
      echo "Valid types: feat, fix, chore, docs, style, refactor, perf, test, ci" >&2
      return 1
    fi

    local type="$1"
    shift
    local msg="$*"

    git commit -m "$type: $msg"
  }

  _gc_completion() {
    local -a commit_types
    commit_types=(
      'feat:A new feature'
      'fix:A bug fix'
      'chore:Changes to the build process or auxiliary tools and libraries'
      'docs:Documentation only changes'
      'style:Changes that do not affect the meaning of the code'
      'refactor:A code change that neither fixes a bug nor adds a feature'
      'perf:A code change that improves performance'
      'test:Adding missing tests or correcting existing tests'
      'ci:Changes to CI configuration files and scripts'
    )

    _describe 'commit types' commit_types
  }

  compdef _gc_completion gc
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
