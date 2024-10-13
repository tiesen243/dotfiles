# My arch linux config with Hyprland

![preview](./assets/preview.png)

## Installation

1. Clone this repository

```bash
git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles
```

2. Install `yay`

```bash
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
rm -rf ~/yay
```

3. Install all packages

```bash
yay -S zsh hyprpaper hyprpicker hypridle hyprlock wlogout wofi pavucontrol brightnessctl playerctl floorp-bin cliphist wl-clipboard grim slurp thunar gvfs lsd bat nwg-look p7zip fastfetch btop
```

4. Install `oh-my-zsh`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Next, link my custom zsh theme to `~/.oh-my-zsh/custom/themes`

```bash
ln -s ~/dotfiles/zsh/themes/yuki.zsh-theme ~/.oh-my-zsh/custom/themes/yuki.zsh-theme
```

Then, install zsh plugins

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

5. If Japanese/Chinese/Korean font not display correctly

```bash
yay -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

6. Optional: Install `miniconda3` for python and `nvm` for nodejs development environment

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

## Usage

Link all config files to your `.config` directory

```bash
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/hypr ~/.config/hypr
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/zsh/config.zsh ~/.zshrc
```

## Customization

1. Change Themes

```bash
cp -a ~/dotfiles/themes/. ~/
```

Then, you can change the themes by `nwg-look` command

2. Change Wallpaper in `~/dotfiles/hypr/hyprpaper.conf`

```bash
preload = ~/path/to/wallpaper
wallpaper = ,~/path/to/wallpaper
```

Or change file in `~/dotfiles/assets/_background.jpg`

## Note:

- If you use `obs-studio`, you can install `wlrobs` dependency for screen recording

```bash
yay -S obs-studio wlrobs
```

## Conclusion

This is my personal config for my arch linux system. You can use it as a reference or clone it to your system. If you have any question, feel free to ask me.

Documentations: [here](https://tiesen.id.vn/blogs/hyprland/)

Optional: You can try my neovim config at [here](https://github.com/tiesen243/nvim)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details
