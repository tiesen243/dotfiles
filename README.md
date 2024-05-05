# My arch linux config with Hyprland

## Table of Contents

1. [How to install](#how-to-install)
2. [How to use](#how-to-use)
3. [How to change the themes](#how-to-change-the-themes)

## How to install

```bash
git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles
```

> Install `yay`

```bash
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
rm -rf ~/yay
```

> Install all dependences

```bash
sudo pacman -S zsh swayidle hyprpaper p7zip wofi pavucontrol thunar gvfs brightnessctl playerctl fastfetch btop copyq wl-clipboard
sudo yay -S swaylock-effects lazygit floorp-bin wlogout
```

> If Jappanese/Chinese/Korean font not display correctly

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

> If you use `nvidia` GPU

```bash
sudo pacman -S nvidia-dkms nvidia-utils
```

Then add this line to end of `/etc/default/grub`

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet nvidia_drm.modeset=1"

sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Then add this line to end of `/etc/mkinitcpio.conf`

```bash
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

sudo mkinitcpio -P
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

> Optional: Install `miniconda3` for python and `nvm` for nodejs development environment

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
source = ~/dotfiles/hypr/hyprland.conf
```

2. Change the content of `~/.config/kitty/kitty.conf` to

```bash
include ~/dotfiles/kitty/kitty.conf
```

3. Copy folder `~/dotfiles/custom` to `~/.oh-my-zsh/custom`

```bash
cp -r ~/dotfiles/custom/themes ~/.oh-my-zsh/custom
```

4. Change the content of `~/.zshrc` to

```bash
source ~/dotfiles/.zshrc
```

## How to change the themes

1. Change Themes

```bash
cp -r ~/dotfiles/.fonts ~/
cp -r ~/dotfiles/.icons ~/
cp -r ~/dotfiles/.themes ~/

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

3. Install `obs-studio` for screen recording

```bash
sudo pacman -S obs-studio
yay -S wlrobs
```

---

### Enjoy it!

Optional: You can try my neovim config at [here](https://github.com/tiesen243/nvim)
