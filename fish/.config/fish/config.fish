alias j="jump"
alias k="kubectl"

fish_vi_key_bindings
set -Ux EDITOR nvim # 'neovim/neovim' text editor

fzf --fish | source
starship init fish | source
zoxide init fish | source
atuin init fish --disable-up-arrow | source

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
