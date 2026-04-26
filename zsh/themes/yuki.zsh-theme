# Yuki Theme v1.0.0
#
# Copyright 2026, All rights reserved
#
# Code licensed under the MIT license
# http://github.com/tiesen243/dotfiles/blob/main/LICENSE

# Initialization {{{
source ~/dotfiles/zsh/themes/async.zsh
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST
async_init
PROMPT=''
# }}}

# Options {{{
# Set to 0 to disable the git status
YUKI_DISPLAY_GIT=${YUKI_DISPLAY_GIT:-1}

# Set to 1 to show the date
YUKI_DISPLAY_TIME=${YUKI_DISPLAY_TIME:-0}
YUKI_TIME_FORMAT="%H:%M"

# Set to 1 to show the 'context' segment
YUKI_DISPLAY_CONTEXT=${YUKI_DISPLAY_CONTEXT:-1}

# Set to 1 to use a new line for commands
YUKI_DISPLAY_NEW_LINE=${YUKI_DISPLAY_NEW_LINE:-0}

# Set to 1 to show full path of current working directory
YUKI_DISPLAY_FULL_CWD=${YUKI_DISPLAY_FULL_CWD:-0}

# Icons
YUKI_ARROW_ICON=${YUKI_ARROW_ICON:-󰣇 }
YUKI_EXECUTED_ICON=${YUKI_EXECUTED_ICON:-λ }
# }}}

# Status segment {{{
yuki_arrow() {
  if [[ "$1" = "start" ]] && ((!YUKI_DISPLAY_NEW_LINE)); then
    print -P "$YUKI_ARROW_ICON"
  elif [[ "$1" = "end" ]] && ((YUKI_DISPLAY_NEW_LINE)); then
    print -P "\n$YUKI_ARROW_ICON"
  fi
}

# arrow is foreground if last command was successful, red if not
PROMPT+='%(?:%F{foreground}:%F{red})%B$(yuki_arrow start)'
# }}}

# Time segment {{{
yuki_time_segment() {
  if ((YUKI_DISPLAY_TIME)); then
    print -P "%D{$YUKI_TIME_FORMAT} "
  fi
}

PROMPT+='%F{foreground}%B$(yuki_time_segment)'
# }}}

# User context segment {{{
yuki_context() {
  if ((YUKI_DISPLAY_CONTEXT)); then
    echo '%n@%m 󱦰 '
  fi
}

PROMPT+='%F{foreground}%B$(yuki_context)'
# }}}

# Directory segment {{{
yuki_directory() {
  if ((YUKI_DISPLAY_FULL_CWD)); then
    print -P '%~ '
  else
    print -P '%c '
  fi
}

PROMPT+='%F{yellow}%B$(yuki_directory)'
# }}}

# Async git segment {{{
ZSH_THEME_GIT_PROMPT_PREFIX="%F{foreground}on %F{blue} %B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "

yuki_git_status() {
  ((!YUKI_DISPLAY_GIT)) && return
  cd "$1" 2>/dev/null || return

  local ref branch lockflag git_status color
  lockflag="--no-optional-locks"
  ref=$(=git $lockflag symbolic-ref --quiet HEAD 2>/dev/null)
  case $? in
    0) branch=${ref#refs/heads/} ;;
    128) return ;;
    *) branch=$(=git $lockflag rev-parse --short HEAD 2>/dev/null) || return ;;
  esac

  if [[ -n $branch ]]; then
    if [[ -n "$(=git $lockflag status --porcelain 2>/dev/null)" ]]; then
      color="%F{yellow}"
    else
      color="%F{green}"
    fi

    echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${color}${branch}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

yuki_git_callback() {
  YUKI_GIT_STATUS="$3"
  zle && zle reset-prompt
  async_stop_worker yuki_git_worker yuki_git_status "$(pwd)"
}

yuki_git_async() {
  async_start_worker yuki_git_worker -n
  async_register_callback yuki_git_worker yuki_git_callback
  async_job yuki_git_worker yuki_git_status "$(pwd)"
}

add-zsh-hook precmd yuki_git_async

PROMPT+='$YUKI_GIT_STATUS'
# }}}

PROMPT+='%(1V:%F{yellow}:%(?:%F{foreground}:%F{red}))%B$(yuki_arrow end)%f%b$YUKI_EXECUTED_ICON'
