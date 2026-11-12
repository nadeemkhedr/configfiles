# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/nadeem/.docker/bin"
# End of Docker Desktop section.

# Add Homebrew binaries to the PATH
# This is done automatically in the terminal
# Its mainly for GUI apps like leaderkey
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end
fish_add_path /usr/local/bin
fish_add_path /Applications/Obsidian.app/Contents/MacOS

fish_vi_key_bindings
set -Ux EDITOR nvim # 'neovim/neovim' text editor
starship init fish | source
zoxide init fish | source
atuin init fish --disable-up-arrow | source
tv init fish | source
# rex (terminal multiplexer) completions
if command -q rex
    rex completion fish | source
end

# Bindings

function j
    jump $argv
end

alias k="kubectl"
# eza
alias ls='eza --group-directories-first --icons=auto'
alias ll='ls -lh --git'
alias la='ll -a'
alias tree='ll --tree --level=5'
alias mux='tmuxinator'
alias tg='terragrunt'
alias tf='terraform'
# fixes window dragging lag (AXVisualSupportAgent leaks ports into WindowServer)
alias clearui='killall AXVisualSupportAgent'

abbr s 'sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder \'Pick a sesh\' --prompt=\'⚡\')"'

# Change default pager
# TODO: fix colors of nvimpager
# set -Ux PAGER "~/.local/bin/nvimpager" # 'lucc/nvimpager'
set -Ux PAGER nvimpager
# NOTE: "noborus/ov" 🎑Feature-rich terminal-based text viewer. It is a so-called terminal pager.
# set -Ux PAGER ov

# For lazygit config change
set -gx XDG_CONFIG_HOME $HOME/.config

# Created by `pipx` on 2025-12-01 13:03:32
set PATH $PATH /Users/nadeem/.local/bin

# https://yazi-rs.github.io/docs/quick-start/
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# If private file exists load it
set -l private_config ~/.config/fish/config_private.fish
if test -f $private_config
    source $private_config
end
