export STARSHIP_CONFIG="$HOME/dotfiles/startship/starship.toml"
export STARSHIP_CACHE="$HOME/.cache/starship/cache"

# >>> nvm initialize >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# <<< nvm initialize <<<

# >>> bun initialize >>>
if [ -d "$HOME/.bun/bin" ]; then
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
if [ -d "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
  eval "$(uv generate-shell-completion zsh)"
fi
# <<< uv initialize <<<

# >>> arm initialize <<<
if [[ -d "$HOME/.arm-linux-gnueabi/bin" ]]; then
  export PATH="$HOME/.arm-linux-gnueabi/bin:$PATH"
fi
# <<< arm initialize <<<
