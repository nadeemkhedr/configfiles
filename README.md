# Config Files

This repo must be cloned in `~/` directory

Run `stow` to symlink everything or select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # My zsh config
```

## Install brew packages

```bash
cd ./brew
brew bundle
```

### Bat

In order for `bat` to use the new theme you need to run this command:

```bash
bat cache --build
```

### Karabiner

#### `yabai` scripts not working in karabiner

Check this issue [here](https://github.com/yqrashawn/GokuRakuJoudo/issues/67),
solution is to run this command:

```bash
sudo launchctl config user path "/usr/local/bin:$PATH"

# Updated brew location do this instead
sudo launchctl config user path "/opt/homebrew/bin:$PATH"

```

### Brew

#### Create a new dump in brew

- `brew bundle dump`

#### Generate `brew-description`

- `brew leaves --installed-on-request | xargs -n1 brew desc > ./brew/brew-description`

### Zap

Install Zap for the terminal to work [here](https://www.zapzsh.org/#repos-container)

### Wezterm custom terminfo

Need to install custom wezterm terminfo [here](https://wezfurlong.org/wezterm/config/lua/config/term.html)

```
tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile
```

### Rust

For cargo to run install rust [here](https://www.rust-lang.org/tools/install)
