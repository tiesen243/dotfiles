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
fi
# <<< bun initialize <<<

# >>> uv initialize >>>
. "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"
# <<< uv initialize <<<
