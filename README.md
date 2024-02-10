# My arch linux config with Hyprland

> This is my arch linux config with Hyprland and use Dracula theme for all application

# Table of Contents

1. [Dependence](#dependence)
2. [How to install](#how-to-install)
3. [How to use](#how-to-use)
4. [How to change the themes](#how-to-change-the-themes)

## Dependence

```bash
sudo pacman -S zsh waybar swayidle hyprpaper p7zip pipewire-jack pipewire-alsa easyeffects pavucontrol
sudo yay -S swaylock-effects lazygit
```

> If Jappanese/Chinese/Korean font not display correctly

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

> If you dont want to use default file manager

```bash
sudo pacman -S thunar gvfs gvfs-backends gvfs-fuse
```

## How to install

```bash
git clone git@github.com:tiesen243/dotfile.git ~/dotfile
```

> Install `yay`

```bash
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
rm -rf ~/yay
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
mkdir -p ~/.miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/.miniconda3/miniconda.sh
bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3
rm -rf ~/.miniconda3/miniconda.sh
~/.miniconda3/bin/conda init zsh
```

```bash
yay -S nvm
```

## How to use

1. Change the content of `~/.config/hypr/hyprland.conf` to

```bash
source ~/dotfile/hypr/hyprland.conf
```

2. Change the content of `~/.config/kitty/kitty.conf` to

```bash
include ~/dotfile/kitty/kitty.conf
```

3. Copy folder `~/dotfile/custom` to `~/.oh-my-zsh/custom`

```bash
cp -r ~/dotfile/custom ~/.oh-my-zsh/custom
```

4. Change the content of `~/.zshrc` to

```bash
source ~/dotfile/.zshrc
```

## How to change the themes

1. Change Themes

```bash
cp -r ~/dotfile/.fonts ~/
cp -r ~/dotfile/.icons ~/
cp -r ~/dotfile/.themes ~/

yay -S nwg-look
```

Then, you can change the themes by `nwg-look` command

2. Change Wallpaper

```bash
sudo pacman -S hyprpaper
touch ~/.config/hypr/hyprpaper.conf

# add the content to hyprpaper.conf
preload = ~/path/to/wallpaper
wallpaper = ,~/path/to/wallpaper
```

---

### Enjoy it!

> Optional: You can try my neovim config at [here](https://github.com/tiesen243/nvim)
