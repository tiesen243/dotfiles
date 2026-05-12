export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

ZSH_THEME="yuki"

plugins=(composer sudo z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ------        Alias        ------
source $HOME/dotfiles/zsh/aliases.zsh

# ------   Helpful Scruipt   ------
source $HOME/dotfiles/zsh/scripts.zsh

# ------ Export Env Variable ------
source $HOME/dotfiles/zsh/exports.zsh

# ------       Plugins       -------
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
