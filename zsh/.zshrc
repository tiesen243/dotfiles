# ------------       History        ------------
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# ------------    Shell Behavior    ------------
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# ------------       Modules        ------------
source "$XDG_CONFIG_HOME/zsh/environment.zsh"
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
source "$XDG_CONFIG_HOME/zsh/plugins.zsh"

# ------------      Completions     ------------
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
