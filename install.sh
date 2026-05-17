#!/usr/bin/env bash

set -e

echo "========================================="
echo "       STARTING DOTFILES INSTALLATION    "
echo "========================================="

# 1. Update system and install base-devel and git
echo "--> Updating system and installing git & base-devel..."
sudo pacman -Syu --needed --noconfirm git base-devel

# 2. Install yay (AUR helper)
if ! command -v yay &> /dev/null; then
    echo "--> yay not found. Installing yay..."
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/yay
else
    echo "--> yay is already installed."
fi

# 3. Clone Dotfiles (Using HTTPS since GitHub login step is removed)
echo "--> Cloning dotfiles from GitHub..."
if [ -d "$HOME/dotfiles" ]; then
    echo "--> ~/dotfiles directory already exists. Pulling latest updates..."
    cd ~/dotfiles && git pull && cd ~
else
    git clone https://github.com/tiesen243/dotfiles.git ~/dotfiles
fi

# 4. Install packages from package.txt
echo "--> Installing packages from the list..."
if [ -f "$HOME/dotfiles/package.txt" ]; then
    yay -S --needed --noconfirm --answerclean All --answerdiff None $(grep -v '^#' ~/dotfiles/package.txt)
else
    echo "⚠️ Warning: ~/dotfiles/package.txt not found!"
fi

# 5. Set ZSH as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "--> Setting zsh as the default shell..."
    chsh -s $(which zsh)
else
    echo "--> zsh is already the default shell."
fi

# 6. Backup specific configs and create symlinks
echo "--> Backing up old specific configs and creating symlinks..."
rm -rf ~/{.cache,.local}

# Create backup directory with a timestamp to avoid overwriting older backups
BACKUP_DIR="$HOME/.config.bak_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

# Define the specific folders you want to link
config_items=(Thunar btop fastfetch git gtk-3.0 gtk-4.0 hypr kitty lazygit lsd matugen nvim quickshell zsh)
for item in "${config_items[@]}"; do
    if [ -e "$HOME/.config/$item" ] || [ -L "$HOME/.config/$item" ]; then
        mv "$HOME/.config/$item" "$BACKUP_DIR/"
    fi
done

# Create the symbolic links
ln -s ~/dotfiles/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lazygit,lsd,matugen,nvim,quickshell,zsh} ~/.config/

# 7. Configure lowercase user directories
echo "--> Configuring lowercase user directories..."
read -p "Do you want to use lowercase user directories? (e.g., downloads, pictures) [y/N]: " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "--> Configuring lowercase user directories..."
    rm -rf ~/{Desktop,Documents,Downloads,Music,Pictures,Projects,Public,Templates,Videos}
    mkdir -p ~/{documents,downloads,pictures,projects,videos}

    ln -sf ~/dotfiles/user-dirs.dirs ~/.config/
    if command -v xdg-user-dirs-update &> /dev/null; then
        xdg-user-dirs-update
    else
        echo "⚠️ Warning: xdg-user-dirs is not installed, skipping user-dirs update."
    fi
else
    echo "--> Skipping lowercase user directories configuration."
fi

echo "--> Making dotfiles scripts executable..."
if [ -d "$HOME/dotfiles/scripts" ]; then
    sudo chmod +x ~/dotfiles/scripts/*
fi

echo "========================================="
echo "   INSTALLATION COMPLETE! PLEASE REBOOT  "
echo "========================================="
