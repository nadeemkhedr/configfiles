# How to change gaps dynamically in aerospace

This is pretty important for ultra wide monitors
Check this issue [here](https://github.com/nikitabobko/AeroSpace/issues/60#issuecomment-3063592746)

## Pre-requisites

[toml-cli](https://github.com/MinseokOh/toml-cli) (installed with `go install github.com/MinseokOh/toml-cli@latest`, need to set up go and add the bin dir to your path).

## When config changes

Anytime aerospace config is updated run this command

```
# in ~/.config/aerospace
cp ~/.config/aerospace/aerospace.toml ~/.config/aerospace/aerospace-gaps.toml
toml-cli merge ~/.config/aerospace/aerospace.toml ~/.config/aerospace/nogaps-override.toml -o ~/.config/aerospace/aerospace-nogaps.toml
```
