#!/bin/bash

echo "Starting installation..."

# Install yay
echo "Installing yay..."
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
rm -rf ~/yay

# Install packages
echo "Installing packages..."
yay -S zsh hyprpaper hyprpicker hypridle hyprlock wlogout wofi pavucontrol brightnessctl playerctl floorp-bin cliphist wl-clipboard grim slurp thunar gvfs lsd bat nwg-look p7zip fastfetch btop commitizen-go localsend lazygit noto-fonts noto-fonts-cjk noto-fonts-emoji github-cli

# Generate ssh key and add to github
echo "Generating ssh key..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
  read -p "Enter your email to generate ssh key: " email
  ssh-keygen -t ed25519 -C "$email"
  echo "To add ssh key to github, choose 'Github.com' -> 'SSH' -> '~/.ssh/id_ed25519.pub'"
  gh auth login
  echo "SSH key generated!"
else
  echo "SSH key already exists!"
fi

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins
echo "Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install miniconda3
read -p "Do you want to install miniconda3? [y/n]: " is_miniconda
if [ $is_miniconda == "y" ]; then
  echo "Installing miniconda3..."
  mkdir -p ~/.miniconda3
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/.miniconda3/miniconda.sh
  bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3
  rm -rf ~/.miniconda3/miniconda.sh
  ~/.miniconda3/bin/conda init zsh
fi

# Install nvm
read -p "Do you want to install nvm? [y/n]: " is_nvm
if [ $is_nvm == "y" ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
fi

# Clone dotfiles
echo "Cloning dotfiles..."
git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles

# Linking dotfiles to .config directory
echo "Linking dotfiles..."
ln -s ~/dotfiles/hypr ~/.config
ln -s ~/dotfiles/btop ~/.config
ln -s ~/dotfiles/kitty ~/.config
ln -s ~/dotfiles/dunst ~/.config
ln -s ~/dotfiles/lazygit ~/.config
ln -s ~/dotfiles/fastfetch ~/.config
ln -s ~/dotfiles/zsh/config.zsh ~/.zshrc
ln -s ~/dotfiles/zsh/themes/yuki.zsh-theme ~/.oh-my-zsh/custom/themes

# Copying themes
echo "Copying themes..."
cp -a ~/dotfiles/themes/. ~/
echo "Themes copied! You can change the theme in 'nwg-look'."

# Install obs-studio
read -p "Do you want to install obs-studio? [y/n]: " is_obs
if [ $is_obs == "y" ]; then
  yay -S obs-studio wlrobs-hg
fi

echo "Cleaning up..."
yay -Qdtq | yay -Rns -

echo "Installation completed!"
