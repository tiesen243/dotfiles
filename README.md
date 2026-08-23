This repository contains my personal dotfiles for configuring Linux. The setup uses Hyprland / Niri as the desktop environment (Wayland compositor) and Quickshell for building custom desktop components.

## Preview

<img width="1920" height="1080" alt="Screenshot_2026-08-23_164152" src="https://github.com/user-attachments/assets/19edefe5-0752-43df-b565-8f9f5fa3a8cf" />

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
rm -rf ~/.config/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lazygit,lsd,nvim,zsh}
ln -s ~/dotfiles/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lazygit,lsd,nvim,zsh} ~/.config
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
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
```

Final, make all scripts in the `dotfiles/scripts` directory executable:

```bash
sudo chmod +x ~/dotfiles/scripts/*
```

2.2. For Windows

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

## Conclusion

This is my personal config for my arch linux system. You can use it as a reference or clone it to your system. If you have any question, feel free to ask me.

My blog: [here](https://tiesen.id.vn/blogs/arch-linux-setup/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
