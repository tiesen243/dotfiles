# My arch linux config with Hyprland

# Table of Contents

1. [Dependence](#dependence)
2. [How to install](#how-to-install)
3. [How to use](#how-to-use)
4. [How to change the wallpaper](#how-to-change-the-wallpaper)

## Dependence

install `nwg-look` for apply themes

dependence: `zsh`, `oh-my-zsh`, `waybar`, `swaylock-effects`, `swayidle`, `lazygit`, `miniconda3`

## How to install

```bash
git clone git@github.com:tiesen243/dotfile.git ~/dotfile
```

## How to use

- Change the content of `~/.config/hypr/hyprland.conf` to

```bash
source ~/dotfile/hypr/hyprland.conf
```

- Change the content of `~/.config/kitty/kitty.conf` to

```bash
include ~/dotfile/kitty/kitty.conf
```

- Move `./.zshrc` folder to `~/.zshrc`
- Move `./.fonts` folder to `~/.fonts`
- Move `./.icons` folder to `~/.icons`
- Move `./.themes` folder to `~/.themes`
- Move `~/dotfile/custom` folder to `~/.oh-my-zsh`

## How to change the wallpaper

```bash
touch ~/.config/hypr/hyprpaper.conf

# add the content to hyprpaper.conf
preload = ~/path/to/wallpaper
wallpaper = ,~/path/to/wallpaper
```

# Enjoy it!
