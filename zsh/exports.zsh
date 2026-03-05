export EDITOR="nvim"

# >>> nvm initialize >>>
if [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi
# <<< nvm initialize <<<

# >>> bun initialize >>>
if [ -d "$HOME/.bun" ]; then
  export PATH="$HOME/.bun/bin:$PATH"

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `bun`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_bun" ]]; then
    typeset -g -A _comps
    autoload -Uz _bun
    _comps[bun]=_bun
  fi

  SHELL=zsh bun completions >|"$ZSH_CACHE_DIR/completions/_bun" && compinit
fi
# <<< bun initialize <<<

# >>> uv initialize >>>
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
  eval "$(uv generate-shell-completion zsh)"
fi
# <<< uv initialize <<<

# >>> android-sdk initialize >>>
if [ -d "/opt/android-sdk" ]; then
  export ANDROID_HOME="/opt/android-sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin"
fi
# <<< android-sdk initialize <<<
