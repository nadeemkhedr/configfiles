# Config Files

Run `stow` to symlink everything or select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # My zsh config
```

## FAQ

### Karabiner

#### `yabai` scripts not working in karabiner

Check this issue [here](https://github.com/yqrashawn/GokuRakuJoudo/issues/67), solution is to run this command:

```bash
sudo launchctl config user path "/usr/local/bin:$PATH"
```
