# My arch linux config with Hyprland

![preview](./assets/preview.png)

## Table of Contents

1. [How to install](#how-to-install)
2. [How to use](#how-to-use)
3. [How to change the themes](#how-to-change-the-themes)

## How to install

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

3. Install all dependences

```bash
sudo pacman -S zsh hypridle hyprpaper hyprlock p7zip wofi pavucontrol gvfs brightnessctl playerctl fastfetch btop cliphist wl-clipboard xfce4-settings grim slurp lsd cowsay
sudo yay -S lazygit floorp-bin wlogout hyprpicker nwg-look yazi
```

4. If Japanese/Chinese/Korean font not display correctly

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

5. Install `oh-my-zsh`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Then, install zsh plugins

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

6. Optional: Install `miniconda3` for python and `nvm` for nodejs development environment

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

2. Copy folder `~/dotfiles/zsh/theme` to `~/.oh-my-zsh/custom/themes`

```bash
cp -r ~/dotfiles/zsh/theme/* ~/.oh-my-zsh/custom/themes
```

Then, change the content of `~/.zshrc` to

```bash
source ~/dotfiles/zsh/config.zsh
```

4. Copy `yazi` config to `~/.config/yazi`

```bash
cp -r ~/dotfiles/yazi/* ~/.config/yazi
```

## How to change the themes

1. Change Themes

```bash
cp -r ~/dotfiles/.fonts ~/
cp -r ~/dotfiles/.icons ~/
cp -r ~/dotfiles/.themes ~/
```

Then, you can change the themes by `nwg-look` command

2. Change Wallpaper in `~/dotfiles/hypr/hyprpaper.conf`

```bash
preload = ~/path/to/wallpaper
wallpaper = ,~/path/to/wallpaper
```

Or change file in `~/dotfiles/assets/background.png`

## Note:

- If you use `obs-studio`, you can install `wlrobs` dependency for screen recording

```bash
sudo pacman -S obs-studio
yay -S wlrobs
```

- If you use `nvm`, `miniconda`, `bun`, add this line to `~/.zshrc`

```bash
# >>> nvm initialize >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# >>> nvm initialize >>>

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tiesen/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tiesen/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tiesen/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tiesen/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> bun initialize >>>
export BUN_PATH="$HOME/.bun"
export PATH="$BUN_PATH/bin:$PATH"
# <<< bun initialize <<<
```

---

## Enjoy it!

Documentations: [here](https://tiesen.id.vn/blog/hyprland/)

Optional: You can try my neovim config at [here](https://github.com/tiesen243/nvim)
