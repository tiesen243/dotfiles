# My arch linux config with Hyprland

install nwg-look for apply themes

dependence: zsh oh-my-zsh waybar swaylock-effects swayidle lazygit miniconda3

# How to install

```bash
git clone git@github.com:tiesen243/dotfile.git ~/dotfile
```

# How to use

change the content of `~/.config/hypr/hyprland.conf` to

```bash
source ~/dotfile/hypr/hyprland.conf
```

change the content of `~/.config/kitty/kitty.conf` to

```bash
include ~/dotfile/kitty/kitty.conf
```

move `./.zshrc` folder to `~/.zshrc`
move `./.fonts` folder to `~/.fonts`
move `./.icons` folder to `~/.icons`
move `./.themes` folder to `~/.themes`
move `~/dotfile/custom` folder to `~/.oh-my-zsh`

Enjoy it!
