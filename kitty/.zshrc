export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

# Plugins
plugins=(git yarn zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting.sh

export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Alias
alias q="exit"
alias vi="nvim"
alias py="python"
alias lg="lazygit"
alias cls="clear"

# Kitty
alias icat="kitten icat"

# Conda
alias ci="conda install"
alias cr="conda remove"
alias ca="conda activate"
alias cde="conda deactivate"
alias cenv="conda env list"
alias cenvc="conda create -n"
alias cenvr="conda env remove -n"
alias cenvu="conda env update -f"
alias cenva="conda env export > requirements.yml"

# >>> nvm initialize >>>
source ~/.nvm/nvm.sh
# <<< nvm initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tiesen/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tiesen/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tiesen/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tiesen/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
