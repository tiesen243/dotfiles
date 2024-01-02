# My arch linux config with Hyprland

# Table of Contents

1. [Dependence](#dependence)
2. [How to install](#how-to-install)
3. [How to use](#how-to-use)
4. [How to change the wallpaper](#how-to-change-the-wallpaper)

## Dependence

Dependence: `zsh`, `waybar`, `swaylock-effects`, `swayidle`, `lazygit`

## How to install

```bash
git clone git@github.com:tiesen243/dotfile.git ~/dotfile
```

> Install `oh-my-zsh`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> Install zsh plugins

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

> Optional: Install `miniconda3` for python and `nvm` for nodejs development environment if you need else you can skip this step and remove nvm and miniconda3 config block in `~/dotfile/.zshrc`

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init zsh
```

```bash
yay -S nvm
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

- Change the content of `~/.zshrc` to

```bash
source ~/dotfile/.zshrc
```

- Move `./.fonts`,`./.icons`, `./.themes` folder to `~/`

> Install `nwg-look` for apply themes

```bash
yay -S nwg-look
```

## How to change the wallpaper

```bash
touch ~/.config/hypr/hyprpaper.conf

# add the content to hyprpaper.conf
preload = ~/path/to/wallpaper
wallpaper = ,~/path/to/wallpaper
```

---

### Enjoy it!

> Optional: You can try my neovim config at [here](https://github.com/tiesen243/nvim)
