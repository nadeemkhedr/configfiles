# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# history
HISTFILE=~/.zsh_history

# sources
plug "$HOME/.config/zsh/zsh-functions"
plug "$HOME/.config/zsh/zsh-prompt"
plug "$HOME/.config/zsh/zsh-aliases"
plug "$HOME/.config/zsh/zsh-exports"
plug "$HOME/.config/zsh/zsh-private"

plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/fzf"
plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"

plug "jocelynmallon/zshmarks"
# custom completions
fpath+="$ZDOTDIR/completion"

#compinit

# try this for aws instead of just using compinit
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# this has to be initialized after bashcompinit
complete -C '/usr/local/bin/aws_completer' aws
source <(kubectl completion zsh)
