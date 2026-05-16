mkdir -p "$XDG_CACHE_HOME/zsh"
fpath=("$XDG_CACHE_HOME/zsh" $fpath)

# >>> nvm initialize >>>
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"

  nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm $@
  }

  local -a node_paths=($NVM_DIR/versions/node/*(/))
  if (( ${#node_paths} > 0 )); then
    export PATH="${node_paths[1]}/bin:$PATH"
  fi
fi
# <<< nvm initialize <<<

# >>> bun initialize >>>
if (( $+commands[bun] )); then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `bun`. Otherwise, compinit will have already done that.
  if [[ ! -f "$XDG_CACHE_HOME/zsh/_bun" ]]; then
    typeset -g -A _comps
    autoload -Uz _bun
    _comps[bun]=_bun
  fi

  if [[ ! -s "$XDG_CACHE_HOME/zsh/_bun" ]]; then
    SHELL=zsh bun completions >| "$XDG_CACHE_HOME/zsh/_bun" &|
  fi
fi
# <<< bun initialize <<<

# >>> cargo initialize >>>
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
# <<< cargo initialize <<<

# >>> android-sdk initialize >>>
if [ -d "/opt/android-sdk" ]; then
  export ANDROID_HOME="/opt/android-sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin"
fi
# <<< android-sdk initialize <<<
