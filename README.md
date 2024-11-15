# My arch linux config with Hyprland

## Preview

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
yay -S zsh hyprpaper hyprpicker hypridle hyprlock \
noto-fonts noto-fonts-cjk noto-fonts-emoji \
cliphist wl-clipboard \
nwg-look pavucontrol \
btop fastfetch rofi \
github-cli lazygit \
bat lsd ripgrep \
thunar gvfs \
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

5. Optional: Install `miniconda3` for python, `nvm` for nodejs development environment and `OBS` for screen record

- Miniconda

```bash
mkdir -p ~/.miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/.miniconda3/miniconda.sh
bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3
rm -rf ~/.miniconda3/miniconda.sh
~/.miniconda3/bin/conda init zsh
```

- NVM

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
```

- If you use `bun` for default node package manager, remember to add this to your `.zshrc`

```bash
# >>> bun initialize >>>
if [ -d "$HOME/.bun/bin" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
fi
# <<< bun initialize <<<
```

- OBS Studio

```bash
yay -S obs-studio wlrobs-hg
```

6. Uninstall unnecessary packages (optional)

```bash
sudo pacman -Runs dolphin htop nano vim wofi
```

## Usage

To apply my config, you can run the following command

```bash
rm ~/.zshrc
rm -rf ~/.config/{btop,dunst,fastfetch,hypr,kitty,nvim,rofi,wlogout,xsettingsd}

ln -s ~/dotfiles/{btop,dunst,fastfetch,hypr,kitty,nvim,rofi,wlogout,xsettingsd} ~/.config
ln -s ~/dotfiles/zsh/themes/yuki.zsh-theme ~/.oh-my-zsh/custom/themes
ln -s ~/dotfiles/zsh/config.zsh ~/.zshrc
```

## Customization

1. Change Themes

```bash
cp -r assets/* ~/.local/share/
```

Then, you can change the themes by `nwg-look` command

2. Change Wallpaper in `~/dotfiles/hypr/misc/hyprpaper.conf`

```bash
$path = /path/to/your/wallpaper
```

Or change file in `~/dotfiles/assets/_background.png`

## Note:

- If you dual boot and get wrong time on windows, run this command:

```bash
timedatectl set-local-rtc 1
```

## Conclusion

This is my personal config for my arch linux system. You can use it as a reference or clone it to your system. If you have any question, feel free to ask me.

My blog: [here](https://tiesen.id.vn/blogs/arch-linux-hyprland-setup/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details
