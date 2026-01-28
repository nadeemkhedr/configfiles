# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository using GNU Stow for symlink management. The repo must be cloned to `~/configfiles` (home directory).

## Directory Structure

Each top-level directory is a "stow package" containing config files that mirror their target location in `~/.config/` or `~/`. For example:
- `fish/.config/fish/` → symlinks to `~/.config/fish/`
- `git/.gitconfig` → symlinks to `~/.gitconfig`

## Common Commands

### Symlinking Configs

```bash
stow */           # Symlink all packages (the '/' ignores README)
stow fish         # Symlink a specific package
stow -D fish      # Remove symlinks for a package
```

### Brew Package Management

```bash
cd ./brew && brew bundle              # Install all packages from Brewfile
brew bundle dump                       # Update Brewfile with current packages
brew leaves --installed-on-request | xargs -n1 brew desc > ./brew/brew-description  # Regenerate descriptions
```

### Bat Theme

After modifying bat themes, rebuild cache:
```bash
bat cache --build
```

## Key Configurations

- **fish**: Primary shell with functions in `fish/.config/fish/functions/`
- **aerospace**: Window manager (tiling)
- **karabiner**: Keyboard remapping (uses goku for config)
- **leaderkey**: App launcher - requires GUI configuration to point to `~/.config/leaderkey`
- **tmux**: Terminal multiplexer with tmuxinator for session management
- **yazi**: File manager with git plugins (git submodule)
- **scripts**: Utility scripts used by leaderkey/kando - require manual symlinks to `/usr/local/bin/`

## Notes

- The `.stow-local-ignore` file excludes README, LICENSE, and VCS files from symlinking
- ranger has a git submodule for devicons plugin
- For karabiner/yabai integration issues, the PATH must be configured via launchctl:
  ```bash
  sudo launchctl config user path "/opt/homebrew/bin:$PATH"
  ```
