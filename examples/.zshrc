source ~/dotfiles/zsh/config.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tiesen/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tiesen/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tiesen/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tiesen/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> nvm initialize >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# <<< nvm initialize <<<

# >>> bun initialize >>>
export BUN_DIR="$HOME/.bun"
if [ -d "$BUN_DIR/bin" ]; then
    export PATH="$BUN_DIR/bin:$PATH"
fi
# <<< nvm initialize <<<
