This repository contains the dotfiles I use to configure and customize my desktop environment and developer tools. It provides a reproducible, modular setup focused on a modern Arch Linux Wayland desktop and development workflow.

It is focused on a modern Arch Linux setup and includes:

- Hyprland / Niri compositor and layout configurations
- Noctalia components for building custom desktop widgets, panels and lockscreen
- Neovim configuration and plugins
- Zsh configuration (with a packaged .zshenv, aliases, and plugins)
- Kitty terminal configuration and helper scripts
- Small utility scripts and a package list to reproduce the environment quickly

This repository is intentionally modular: you can run the one-line installer for a quick setup, or follow the manual steps to inspect and customize each part. There are also Windows PowerShell profile and symlink instructions for reusing parts of this config on Windows.

<img width="1920" height="1080" alt="Screenshot_2026-08-23_164152" src="https://github.com/user-attachments/assets/19edefe5-0752-43df-b565-8f9f5fa3a8cf" />

## Features

- Opinionated Hyprland and Niri configs with modular components (see `hypr/` and `niri/`)
- Noctalia TOML components for panels, widgets and lockscreen (`noctalia/`)
- Reproducible package list (package.txt) and interactive installer (`install.sh`)
- Neovim Lua config (`nvim/`) with LSP configs
- Zsh environment, aliases and plugin list (`zsh/`)
- Kitty terminal enhancements (`kitty/`)
- Cross-platform snippets: PowerShell profile and aliases for Windows (`powershell/`)

## Automatic install (Recommended)

To download and run the installer automatically, copy and paste the following command into your terminal.

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/tiesen243/dotfiles/main/install.sh")
```

## Manual installation

If you prefer to inspect what goes onto your system, want to customize the setup, or need to troubleshoot a specific step, you can follow the step-by-step breakdown below.

### 1. Install necessary packages

1.1. Install `yay`

```bash
pacman -Syu --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
rm -rf ~/yay
```

1.2. Install packages from `package.txt`

```bash
yay -S --needed --noconfirm --answerclean All --answerdiff --None $(grep -v '^#' ~/dotfiles/package.txt)
```

1.3. Set `zsh` as the default shell

```bash
chsh -s $(which zsh)
```

### 2. Apply configuration

2.1. For Linux

```bash
git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles
```

Then, remove existed config and create the symbolic links to the config files

```bash
rm -rf ~/{.cache,.local,.zshrc}
rm -rf ~/.config/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lsd,nvim,zsh}
ln -s ~/dotfiles/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lsd,nvim,zsh} ~/.config
ln -s ~/dotfiles/zsh/.zshenv ~/.zshenv

# For who like lowercase stuffs
rm -rf ~/{Desktop,Documents,Downloads,Music,Pictures,Projects,Public,Templates,Videos} && mkdir -p ~/{documents,downloads,pictures,projects,videos}
cat <<EOF > "$HOME/.config/user-dirs.dirs"
XDG_DESKTOP_DIR="\$HOME/"
XDG_DOWNLOAD_DIR="\$HOME/downloads"
XDG_TEMPLATES_DIR="\$HOME/"
XDG_PUBLICSHARE_DIR="\$HOME/"
XDG_DOCUMENTS_DIR="\$HOME/documents"
XDG_MUSIC_DIR="\$HOME/"
XDG_PICTURES_DIR="\$HOME/pictures"
XDG_VIDEOS_DIR="\$HOME/videos"
XDG_PROJECTS_DIR="\$HOME/projects"
EOF
xdg-user-dirs-update
```

Next, configure git by creating `~/.config/git/config.local` with the following content (replace the name and email with your own):

```bash
[user]
  name = arch-btw
  email = example@arch.btw
```

Next, enable some services

```bash
# ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed
sudo ufw logging on
sudo ufw logging low
sudo ufw --force enable
sudo systemctl enable --now ufw.service

# bluetooth
sudo systemctl enable --now bluetooth.service

# power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon.service

# docker
yay -S --needed --noconfirm docker docker-buildx docker-compose
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
```

2.2. For Windows

```powershell
git clone git clone git@github.com:tiesen243/dotfiles.git $HOME\dotfiles
```

Then, create the symbolic links to the config files (make sure to run Terminal as administrator)

```powershell
Remove-Item -Force -Recurse $HOME\.config\fastfetch
Remove-Item -Force -Recurse $HOME\dotfiles\git
Remove-Item -Force -Recurse $HOME\AppData\Local\nvim
Remove-Item -Force -Recurse $HOME\Documents\WindowsPowerShell

New-Item -ItemType SymbolicLink -Path $HOME\.config\fastfetch -Target $HOME\dotfiles\fastfetch
New-Item -ItemType SymbolicLink -Path $HOME\dotfiles\git -Target $HOME\dotfiles\git
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\nvim -Target $HOME\dotfiles\nvim
New-Item -ItemType SymbolicLink -Path $HOME\Documents\WindowsPowerShell -Target $HOME\dotfiles\powershell
```

## Conclusion

This is my personal config for my arch linux system. You can use it as a reference or clone it to your system. If you have any question, feel free to ask me.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
