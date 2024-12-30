# -*- mode: sh; -*-
# vim: set ft=sh :
# Yuki Theme v1.0.0
#
# Copyright 2024, All rights reserved
#
# Code licensed under the MIT license
# http://github.com/tiesen243/dotfiles/blob/main/LICENSE
#
# @author Tiesen <ttien56906@gmail.com>
# @website https://tiesen.id.vn

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

# Set to 1 to show the 'context' segment
YUKI_DISPLAY_CONTEXT=${YUKI_DISPLAY_CONTEXT:-1}

# Changes the triangle icon
YUKI_ARROW_ICON=${YUKI_ARROW_ICON:-▲ }
YUKI_EXECUTED_ICON=${YUKI_EXECUTED_ICON:-󰘧 }

# Set to 1 to use a new line for commands
YUKI_DISPLAY_NEW_LINE=${YUKI_DISPLAY_NEW_LINE:-0}

# Set to 1 to show full path of current working directory
YUKI_DISPLAY_FULL_CWD=${YUKI_DISPLAY_FULL_CWD:-0}

# function to detect if git has support for --no-optional-locks
yuki_test_git_optional_lock() {
  local git_version=${DEBUG_OVERRIDE_V:-"$(git version | cut -d' ' -f3)"}
  local git_version="$(git version | cut -d' ' -f3)"
  # test for git versions < 2.14.0
  case "$git_version" in
    [0-1].*)
      echo 0
      return 1
      ;;
    2.[0-9].*)
      echo 0
      return 1
      ;;
    2.1[0-3].*)
      echo 0
      return 1
      ;;
  esac

  # if version > 2.14.0 return true
  echo 1
}

# use --no-optional-locks flag on git
YUKI_GIT_NOLOCK=${YUKI_GIT_NOLOCK:-$(yuki_test_git_optional_lock)}

# time format string
if [[ -z "$YUKI_TIME_FORMAT" ]]; then
  YUKI_TIME_FORMAT="%H:%M"
  # check if locale uses AM and PM
  if locale -ck LC_TIME 2>/dev/null | grep -q '^t_fmt="%r"$'; then
    YUKI_TIME_FORMAT="%-I:%M%p"
  fi
fi
# }}}

# Status segment {{{
yuki_arrow() {
  if [[ "$1" = "start" ]] && (( ! YUKI_DISPLAY_NEW_LINE )); then
    print -P "$YUKI_ARROW_ICON"
  elif [[ "$1" = "end" ]] && (( YUKI_DISPLAY_NEW_LINE )); then
    print -P "\n$YUKI_ARROW_ICON"
  fi
}

# arrow is foreground if last command was successful, red if not
PROMPT+='%(?:%F{foreground}:%F{red})%B$(yuki_arrow start)'
# }}}

# Time segment {{{
yuki_time_segment() {
  if (( YUKI_DISPLAY_TIME )); then
    print -P "<%D{$YUKI_TIME_FORMAT} /> "
  fi
}

PROMPT+='%F{foreground}%B$(yuki_time_segment)'
# }}}

# User context segment {{{
yuki_context() {
  if (( YUKI_DISPLAY_CONTEXT )); then
    echo '%n@%m 󱦰 '
  fi
}

PROMPT+='%F{foreground}%B$(yuki_context)'
# }}}

# Directory segment {{{
yuki_directory() {
  if (( YUKI_DISPLAY_FULL_CWD )); then
    print -P '%~ '
  else
    print -P '%c '
  fi
}

PROMPT+='%F{yellow}%B$(yuki_directory)'
# }}}

# Async git segment {{{
yuki_git_status() {
  (( ! YUKI_DISPLAY_GIT )) && return
  cd "$1"

  local ref branch lockflag

  (( YUKI_GIT_NOLOCK )) && lockflag="--no-optional-locks"

  ref=$(=git $lockflag symbolic-ref --quiet HEAD 2>/dev/null)

  case $? in
    0)   ;;
    128) return ;;
    *)   ref=$(=git $lockflag rev-parse --short HEAD 2>/dev/null) || return ;;
  esac

  branch=${ref#refs/heads/}

  if [[ -n $branch ]]; then
    echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}"

    local git_status icon
    git_status="$(LC_ALL=C =git $lockflag status 2>&1)"

    if [[ "$git_status" =~ 'new file:|deleted:|modified:|renamed:|Untracked files:' ]]; then
      echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi

    echo -n "$ZSH_THEME_GIT_PROMPT_SUFFIX"
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

ZSH_THEME_GIT_PROMPT_PREFIX="%F{blue}%B("
ZSH_THEME_GIT_PROMPT_CLEAN=") %F{green}%Bᗜˬᗜ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %F{yellow}%Bᗜ˰ᗜ "
ZSH_THEME_GIT_PROMPT_SUFFIX=""%f%b""
# }}}

# Linebreak {{{
PROMPT+='%F{foreground}%B$(yuki_arrow end)'
# }}}

# Ensure effects are reset
PROMPT+='%f%b$YUKI_EXECUTED_ICON'
