ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

_zplugin_load() {
  local plugin_path="$ZPLUGINDIR/$2"
  if  [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Cloning $2 from $1..."
    git clone --depth=1 "https://github.com/$1/$2.git" "$plugin_path" \
      || { echo "Failed to clone $2 from $1." >&2; return 1; }

    if [[ -f "$plugin_path/$2.zsh" ]]; then
      source "$plugin_path/$2.zsh"
    elif [[ -f "$plugin_path/$2.plugin.zsh" ]]; then
      source "$plugin_path/$2.plugin.zsh"
    else
      echo "Failed to source $2: No valid entry point found." >&2
      return 1
    fi
  fi
}

# ------------     Load Plugins     ------------
_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-syntax-highlighting
_zplugin_load agkozak zsh-z

# ------------    Config Plugins    ------------
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSHZ_DATA="$XDG_CACHE_HOME/zsh/z"
