# enable this and last line to profile start up time
# zmodload zsh/zprof

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"


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
plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"
# we could use atuin instead, but I like this better
plug "zsh-users/zsh-history-substring-search"
plug "Aloxaf/fzf-tab"
plug "jocelynmallon/zshmarks"


# history
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE
# HISTORY
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.
# END HISTORY


# custom completions
fpath+="$ZDOTDIR/completion"

#compinit

# try this for aws instead of just using compinit
# autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# this has to be initialized after bashcompinit
# complete -C '/usr/local/bin/aws_completer' aws
source <(kubectl completion zsh)

# Enable this and first time to profile startup time
# zprof
