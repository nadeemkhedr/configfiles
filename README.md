# Config Files

This repo must be cloned in `~/` directory

Run `stow` to symlink everything or select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # My zsh config
```

## Fish

Make fish the default terminal

```bash
chsh -s $(which fish)
```

## leader-key

Assign `options+space` to leaderkey

After installing leader-key using `brew` need to configure it from the GUI
to look for the config in `~/.config/leaderkey`

## Scripts

I am using different scripts to use with different apps
need to soft link the scripts to be used globally.
These scripts are mainly used with `leaderkey` and `kando`

```bash
sudo ln -s ~/scripts/music-player.sh /usr/local/bin/music-player
sudo ln -s ~/scripts/open-browser.sh /usr/local/bin/open-browser
sudo ln -s ~/scripts/send-keys.sh /usr/local/bin/send-keys
sudo ln -s ~/scripts/toggle-desk.sh /usr/local/bin/toggle-desk
sudo ln -s ~/scripts/open-new-osa.sh /usr/local/bin/open-new-osa
```

## Bat

In order for `bat` to use the new theme you need to run this command:

```bash
bat cache --build
```

## Karabiner

### `yabai` scripts not working in karabiner

Check this issue [here](https://github.com/yqrashawn/GokuRakuJoudo/issues/67),
solution is to run this command:

```bash
sudo launchctl config user path "/usr/local/bin:$PATH"

# Updated brew location do this instead
sudo launchctl config user path "/opt/homebrew/bin:$PATH"

```

## Brew

### Install brew packages

```bash
cd ./brew
brew bundle
```

### Create a new dump in brew

- `brew bundle dump`

### Generate `brew-description`

- `brew leaves --installed-on-request | xargs -n1 brew desc > ./brew/brew-description`

## Macos config commands

```bash
# Disable animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Ctrl + CMD and drag any part of the window
defaults write -g NSWindowShouldDragOnGesture -bool true

# Fast key repeat
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
```

## Rust

For cargo to run install rust [here](https://www.rust-lang.org/tools/install)
