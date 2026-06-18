# ------------       General        ------------
alias icat="kitten icat"
alias cls="clear"
alias q="exit"
alias v="nvim"

# ------------    Pacman / Yay      ------------
alias pu='sudo pacman -Syu'
alias ps='pacman -Ss'
alias pi='sudo pacman -S'
alias pr='sudo pacman -Rns'
alias pc='sudo pacman -Rns $(pacman -Qtdq)'
alias pq='pacman -Qi'
alias pl='pacman -Ql'

if (( $+commands[yay] )); then
  alias yu='yay -Syu'
  alias ys='yay -Ss'
  alias yi='yay -S'
  alias yr='yay -Rns'
  alias yc='yay -Yc'
fi

# ------------          LS          ------------
if (( $+commands[lsd] )); then
  alias ls='lsd'
  
  alias lld='lsd -l --directory-only'
  alias lt='lsd --tree --depth 3'
  alias lla='lsd -la'
  alias la='lsd -a'
  alias ll='lsd -l'
else
  alias ll='ls -lh'
  alias la='ls -A'
  alias lla='ls -lah'
fi

# ------------        Git           ------------
if (( $+commands[git] )); then
  alias g='git'
  
  alias gs='git status -sb'
  alias gl='git log --oneline --graph --decorate'
  alias gd='git diff'
  
  alias ga='git add'
  alias gaa='git add --all'
  alias gc='git commit -m'
  alias gca='git commit --amend'

  alias gp='git push'
  alias gu='git pull'
  alias gf='git fetch'
  
  
  alias gsw='git switch'
  alias gsc='git switch -c'
  alias gsm='git switch main'
  alias gsd='git switch dev'
  alias gswb='git switch -'
  
  alias grs='git restore'
  alias grsh='git restore --hard'
  alias grss='git restore --staged'
  
  alias gst='git stash'
  alias gstp='git stash pop'
  
  if (( $+commands[gh] )); then
    alias gr='gh repo'
    alias grc='gh repo create'
    alias grd='gh repo delete'
    alias grf='gh repo fork'
    alias grl='gh repo clone'
    alias grv='gh repo view'
    alias grr='gh repo rename'
  else
    alias grl='git clone'
  fi

  function gcz() {
    local types=(feat chore style fix docs refactor test ci build perf revert)
    local type=$(print -l "${types[@]}" | fzf --height=40% --layout=reverse --prompt="Select commit type: ")
    if [[ -z "$type" ]]; then
      return 1
    fi

    print -n "Enter scope (optional, e.g., auth, api): " && read scope
    scope=$(echo "$scope" | tr -d '[:space:]')

    print -n "Enter commit message: " && read message
    if [[ -z "$message" ]]; then
      echo "❌ Error: Commit message is required."
      return 1
    fi

    local final_msg=""
    if [[ -n "$scope" ]]; then
      final_msg="${type}(${scope}): ${message}"
    else
      final_msg="${type}: ${message}"
    fi

    git commit -m "$final_msg"
  }
fi

if (( $+commands[lazygit] )); then
  alias lg='lazygit'
fi

# ------------         Bun          ------------
if (( $+commands[bun] )); then
  alias bi='bun install'
  alias ba='bun add'
  alias bad='bun add -d'
  alias bap='bun add -p'
  alias bR='bun remove'
  alias bu='bun update'
  alias bU='bun update --interactive --recursive'

  alias bx='bunx --bun'
  alias bd='bun --bun run dev'
  alias bb='bun --bun run build'
  alias bs='bun --bun run start'
  alias br='bun run'

  alias b='bun'
  alias bt='bun test'
fi
