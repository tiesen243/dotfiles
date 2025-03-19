export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

ZSH_THEME="yuki"

plugins=(bun git git-commit gitignore sudo vi-mode z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ------        Alias        ------
source $HOME/dotfiles/zsh/aliases.zsh

# ------   Helpful Scruipt   ------
source $HOME/dotfiles/zsh/scripts.zsh

# ------ Export, Env Variable ------
source $HOME/dotfiles/zsh/exports.zsh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/tiesen/.dart-cli-completion/zsh-config.zsh ]] && . /home/tiesen/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

