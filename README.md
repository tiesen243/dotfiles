# My arch linux config with Hyprland

## Preview

### Desktop

![preview-01](./assets/preview-01.png)

### Terminal

![preview-02](./assets/preview-02.png)

### Rofi

![preview-03](./assets/preview-03.png)

### Hyprlock 

![preview-04](./assets/preview-04.png)

## Installation

1. Install `yay`

```bash
pacman -Syu --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
rm -rf ~/yay
```

3. Install all packages

```bash
yay -S fastfetch hyperidle hyprlock hyprpaper hyprpicker rofi-wayland waybar xdg-desktop-portal-hyprland-git zsh \
noto-fonts noto-fonts-cjk noto-fonts-emoji \
brightnessctl lsd playerctl ripgrep unzip \
ffmpeg zen-browser-bin \
cliphist wl-clipboard \
nwg-look pavucontrol \
github-cli lazygit\
grim slurp
```

4. Install `oh-my-zsh`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> Remember to choose `zsh` as your default shell

Then, install zsh plugins

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

5. Optional: Install some stuffs

- UV (Python package manager)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

- NVM (Node Version Manager)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
```

6. Uninstall unnecessary packages (optional)

```bash
sudo pacman -Runs htop nano vim wofi
```

## Usage

1. To apply my config, you can run the following command:

```bash
git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles
```

Then, create the symbolic links to the config files

```bash
rm ~/.zshrc
rm -rf ~/.config/{dunst,fastfetch,hypr,kitty,lazygit,lsd,nvim,rofi,waybar}

ln -s ~/dotfiles/{dunst,fastfetch,hypr,kitty,lazygit,lsd,nvim,rofi,waybar} ~/.config
ln -s ~/dotfiles/zsh/themes/yuki.zsh-theme ~/.oh-my-zsh/custom/themes
ln -s ~/dotfiles/zsh/config.zsh ~/.zshrc
```

2. Change Wallpaper in `~/dotfiles/hypr/hyprpaper.conf`

```bash
$path = /path/to/your/wallpaper
```

Or change file in `~/dotfiles/assets/_background.png`

> [!TIP]
> If windows display wrong time when dual boot, run this command:

```bash
timedatectl set-local-rtc 1
```

## Conclusion

This is my personal config for my arch linux system. You can use it as a reference or clone it to your system. If you have any question, feel free to ask me.

My blog: [here](https://tiesen.id.vn/blogs/arch-linux-hyprland-setup/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
