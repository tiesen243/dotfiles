export ZDOTDIR="$HOME/.config/zsh"

# ------------ XDG Base Directories ------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ------------        Editor        ------------
export EDITOR="nvim"
export VISUAL="$EDITOR"

# ------------         GPG          ------------
export GPG_TTY=$(tty)

# ------------         PATH         ------------
export PATH="$HOME/.local/bin:$PATH"
