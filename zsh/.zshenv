
# ------------ XDG Base Directories ------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export WM_MARGIN=4

# -----------          Zsh          ------------
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ------------        Editor        ------------
export EDITOR="nvim"
export VISUAL="$EDITOR"

# ------------         GPG          ------------
export GPG_TTY=$(tty)

# ------------        NVIDIA        ------------
export __GL_SHADER_DISK_CACHE_PATH="$HOME/.cache/nvidia"
export CUDA_CACHE_PATH="$HOME/.cache/nvidia/ComputeCache"

# ------------         PATH         ------------
export PATH="$HOME/.local/bin:$PATH"
