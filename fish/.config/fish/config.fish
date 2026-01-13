# Add Homebrew binaries to the PATH
# This is done automatically in the terminal
# Its mainly for GUI apps like leaderkey
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end
fish_add_path /usr/local/bin

# fzf.fish plugin
set fzf_fd_opts -H -E .git

fish_vi_key_bindings
set -Ux EDITOR nvim # 'neovim/neovim' text editor

fzf --fish | source
starship init fish | source
zoxide init fish | source
atuin init fish --disable-up-arrow | source

# Bindings

alias j="jump"

alias k="kubectl"
# eza
alias ls='eza --group-directories-first --icons=auto'
alias ll='ls -lh --git'
alias la='ll -a'
alias tree='ll --tree --level=2'
alias oo='cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Mind'

abbr s 'sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder \'Pick a sesh\' --prompt=\'⚡\')"'

# Change default pager
# TODO: fix colors of nvimpager
# set -Ux PAGER "~/.local/bin/nvimpager" # 'lucc/nvimpager'
set -Ux PAGER nvimpager
# NOTE: "noborus/ov" 🎑Feature-rich terminal-based text viewer. It is a so-called terminal pager.
# set -Ux PAGER ov

# Created by `pipx` on 2025-12-01 13:03:32
set PATH $PATH /Users/nadeem/.local/bin

# If private file exists load it
set -l private_config ~/.config/fish/config_private.fish
if test -f $private_config
    source $private_config
end
