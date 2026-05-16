# Arch Linux / CachyOS config with Hyprland

This repository contains my personal dotfiles for configuring Linux. The setup uses Hyprland as the primary desktop environment (Wayland compositor) and Quickshell for building custom desktop components.

## Preview

https://github.com/user-attachments/assets/335b0dc0-46db-4cf3-91a2-a33d711e60d3

### Overview

![preview-01](./assets/preview-01.png)

![preview-02](./assets/preview-02.png)

### Kitty terminal

![preview-03](./assets/preview-03.png)

### App launcher

![preview-04](./assets/preview-04.png)

### Clipboard manager

![preview-05](./assets/preview-05.png)

### Lock screen

![preview-06](./assets/preview-06.png)

### Neovim

![preview-07](./assets/preview-07.png)

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
yes | yay -S --answerclean All --answerdiff None \
  # Hyprland & Shell components
  hypridle hyprpolkitagent quickshell xdg-desktop-portal-hyprland \
  # Fonts
  noto-fonts noto-fonts-cjk noto-fonts-emoji otf-geist otf-geist-mono-nerd \
  # Terminal & CLI tools
  kitty btop fastfetch fzf zsh lazygit lsd ripgrep unzip github-cli \
  # Media & notifications
  ffmpeg brightnessctl playerctl libnotify grim slurp cliphist wl-clipboard \
  # Theming
  adw-gtk-theme capitaine-cursors matugen \
  # File manager
  thunar thunar-volman gvfs tumbler
  # Vietnamese input method (optional)
  fcitx5-lotus-bin fcitx5-config-qt
```

3.1. Set `zsh` as the default shell

```bash
chsh -s $(which zsh)
```

4. Optional: Install some stuffs

- UV (Python package manager)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

- NVM (Node Version Manager)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
```

5. Set up github

Open the browser and login to your github account, then run the following command to set up the SSH key for your github account.

```bash
gh auth login
```

6. Uninstall unnecessary packages (optional)

```bash
sudo pacman -Runs dunst dolphin htop nano vim wofi
```

## Usage

1. To apply my config, you can run the following command:

   1.1. For Linux

   ```bash
   git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles
   ```

   Then, create the symbolic links to the config files

   ```bash
   rm ~/.zshrc
   rm -rf ~/.config/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lazygit,lsd,matugen,nvim,quickshell,zsh,user-dirs.dirs}
   ln -s ~/dotfiles/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lazygit,lsd,matugen,nvim,quickshell,zsh,user-dirs.dirs} ~/.config
   ```

   Final, make all scripts in the dotfiles/scripts directory executable

   ```bash
   sudo chmod +x ~/dotfiles/scripts/*
   ```

   1.1. For Windows

   ```powershell
   git clone git clone git@github.com:tiesen243/dotfiles.git $HOME\dotfiles
   ```

   Then, create the symbolic links to the config files (make sure to run Terminal as administrator)

   ```powershell
   Remove-Item -Force -Recurse $HOME\Documents\WindowsPowerShell
   Remove-Item -Force -Recurse $HOME\AppData\Local\nvim

   New-Item -ItemType SymbolicLink -Path $HOME\Documents\WindowsPowerShell -Target $HOME\dotfiles\powershell
   New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\nvim -Target $HOME\dotfiles\nvim
   ```

2. Change Wallpaper

Add your preferred wallpapers to ~/dotfiles/assets/wallpapers/. You can then toggle the wallpaper selector by open the Start Menu using Super+A and click the Wallpaper Selector icon (located at the bottom-right corner of the quick action buttons). After changing the wallpaper, it automatically generates color schemes based on the wallpaper and applies it to the system by using Matugen.

3. Add your avatar to `/usr/share/sddm/faces/$USER.face.icon` to show in the lock screen

4. Restart your system and enjoy it!

## Conclusion

This is my personal config for my arch linux system. You can use it as a reference or clone it to your system. If you have any question, feel free to ask me.

My blog: [here](https://tiesen.id.vn/blogs/arch-linux-hyprland-setup/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
