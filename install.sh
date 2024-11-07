#!/bin/bash

txtcyan='\033[0;36m'
txtblue='\033[0;34m'
txtgreen='\033[0;32m'
txtyellow='\033[0;33m'
txtmagenta='\033[0;35m'
txtreset='\033[0m'

echo -e "$(
cat << EOM
\033[38;2;23;147;209m                   ▄
                  ▟█▙
                 ▟███▙
                ▟█████▙
               ▟███████▙            ██╗   ██╗██╗   ██╗██╗  ██╗██╗
              ▂▔▀▜██████▙           ╚██╗ ██╔╝██║   ██║██║ ██╔╝██║
             ▟██▅▂▝▜█████▙           ╚████╔╝ ██║   ██║█████╔╝ ██║
            ▟█████████████▙           ╚██╔╝  ██║   ██║██╔═██╗ ██║    
           ▟███████████████▙           ██║   ╚██████╔╝██║  ██╗██║   
          ▟█████████████████▙          ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝
         ▟███████████████████▙                @tiesen243
        ▟█████████▛▀▀▜████████▙
       ▟████████▛      ▜███████▙
      ▟█████████        ████████▙
     ▟██████████        █████▆▅▄▃▂
    ▟██████████▛        ▜█████████▙
   ▟██████▀▀▀              ▀▀██████▙
  ▟███▀▘                       ▝▀███▙
 ▟▛▀                               ▀▜▙
▟▘                                   ▝▙ ${txtreset}
EOM
)"

# Install packages
echo -e "$(
cat << EOM
------------------------------------------------------------------------

${txtblue}██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗          █████╗ ██████╗ ██████╗ 
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║         ██╔══██╗██╔══██╗██╔══██╗
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║         ███████║██████╔╝██████╔╝
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║         ██╔══██║██╔═══╝ ██╔═══╝ 
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗    ██║  ██║██║     ██║     
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝${txtreset}

------------------------------------------------------------------------
EOM
)"

echo "Installing yay..."
if ! command -v yay &> /dev/null; then
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
  rm -rf ~/yay

  echo "yay installed!"
else
  echo "yay is arleady installed!"
fi

echo "Installing packages..."
yay -Syu zsh hyprpaper hyprpicker hypridle hyprlock wlogout wofi pavucontrol brightnessctl playerctl floorp-bin cliphist wl-clipboard grim slurp thunar gvfs lsd bat nwg-look p7zip fastfetch btop commitizen-go localsend lazygit noto-fonts noto-fonts-cjk noto-fonts-emoji github-cli docker ripgrep vlc
echo "All packages installed!"

# Install miniconda3
if [ ! -d ~/.miniconda3 ]; then
  read -p "Do you want to install miniconda3? [y/n]: " is_miniconda
  if [ $is_miniconda == "y" ]; then
    echo "Installing miniconda3..."

    mkdir -p ~/.miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/.miniconda3/miniconda.sh
    bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3
    rm -rf ~/.miniconda3/miniconda.sh
    ~/.miniconda3/bin/conda init zsh

    echo "Miniconda3 installed!"
  fi
else 
  echo "Miniconda3 is already installed!"
fi

# Install nvm
if [ ! -d ~/.nvm ]; then
  read -p "Do you want to install nvm? [y/n]: " is_nvm
  if [ $is_nvm == "y" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    echo "nvm installed!"
  fi
else
  echo "nvm is already installed!"
fi

# Install obs-studio
if ! command -v obs &> /dev/null; then
  read -p "Do you want to install obs-studio? [y/n]: " is_obs
  if [ $is_obs == "y" ]; then
    echo "Installing obs-studio..."
    yay -S obs-studio wlrobs-hg
    echo "OBS Studio installed!"
  fi
else
  echo "OBS Studio is already installed!"
fi

# git config
echo -e "$(
cat << EOM
------------------------------------------------------------------------

${txtcyan} ██████╗ ██╗████████╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
██╔════╝ ██║╚══██╔══╝    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
██║  ███╗██║   ██║       ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
██║   ██║██║   ██║       ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
╚██████╔╝██║   ██║       ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
 ╚═════╝ ╚═╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝${txtreset}

------------------------------------------------------------------------
EOM
)"

echo "Configuring git..."
git config --global core.editor "nvim"
if [ -z "$(git config --global user.name)" ]; then
  read -p "Enter your name: " name
  git config --global user.name "$name"
fi

if [ -z "$(git config --global user.email)" ]; then
  read -p "Enter your email: " email
  git config --global user.email "$email"
fi

echo "Git config completed!"

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
echo -e "$(
cat << EOM
------------------------------------------------------------------------

${txtmagenta} ██████╗ ██╗  ██╗      ███╗   ███╗██╗   ██╗      ███████╗███████╗██╗  ██╗
██╔═══██╗██║  ██║      ████╗ ████║╚██╗ ██╔╝      ╚══███╔╝██╔════╝██║  ██║
██║   ██║███████║█████╗██╔████╔██║ ╚████╔╝ █████╗  ███╔╝ ███████╗███████║
██║   ██║██╔══██║╚════╝██║╚██╔╝██║  ╚██╔╝  ╚════╝ ███╔╝  ╚════██║██╔══██║
╚██████╔╝██║  ██║      ██║ ╚═╝ ██║   ██║         ███████╗███████║██║  ██║
 ╚═════╝ ╚═╝  ╚═╝      ╚═╝     ╚═╝   ╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝${txtreset}
                                                                        
------------------------------------------------------------------------
EOM
)"

echo "Installing oh-my-zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "oh-my-zsh installed!"
else 
  echo "oh-my-zsh is already installed!"
fi

# Install zsh plugins
echo "Installing zsh plugins..."

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "Zsh plugins installed!"

# Clone dotfiles
echo -e "$(
cat << EOM
------------------------------------------------------------------------

${txtyellow}███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║    ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝${txtreset}
                                                                                                       
------------------------------------------------------------------------
EOM
)"

echo "Cloning dotfiles..."
if [ ! -d ~/dotfiles ]; then
  git clone git@github.com:tiesen243/dotfiles.git ~/dotfiles
  echo "Dotfiles cloned!"
fi

# Copying themes
echo "Copying themes..."
cp -r ~/dotfiles/customsize/* ~/.local/share
echo "Themes copied!"

# Linking dotfiles to .config directory
echo "Linking dotfiles..."

rm ~/.zshrc
rm -rf ~/.oh-my-zsh/custom/themes/yuki.zsh-theme
rm -rf ~/.config/{zsh,hypr,btop,nvim,kitty,dunst,wlogout,lazygit,fastfetch,xsettingsd}

ln -s ~/dotfiles/hypr ~/.config
ln -s ~/dotfiles/btop ~/.config
ln -s ~/dotfiles/nvim ~/.config
ln -s ~/dotfiles/kitty ~/.config
ln -s ~/dotfiles/dunst ~/.config
ln -s ~/dotfiles/wlogout ~/.config
ln -s ~/dotfiles/lazygit ~/.config
ln -s ~/dotfiles/fastfetch ~/.config
ln -s ~/dotfiles/xsettingsd ~/.config
ln -s ~/dotfiles/zsh/config.zsh ~/.zshrc
ln -s ~/dotfiles/zsh/themes/yuki.zsh-theme ~/.oh-my-zsh/custom/themes

echo "Dotfiles linked!"

echo "Cleaning up..."

if [ -n "$(yay -Qdtq)" ]; then
  yay -Runs $(yay -Qdtq)
fi

# remove unnecessary packages
if command -v vim &> /dev/null; then
  sudo pacman -Runs vim
fi

if command -v nano &> /dev/null; then
  sudo pacman -Runs nano
fi 

if command -v dolphin &> /dev/null; then
  sudo pacman -Runs dolphin
fi

echo "Cleaning up completed!"

echo -e "$(
cat << EOM
------------------------------------------------------------------------

${txtgreen} ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗███████╗██████╗ ██╗
██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██╔════╝██╔══██╗██║
██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   █████╗  ██║  ██║██║
██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██╔══╝  ██║  ██║╚═╝
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   ███████╗██████╔╝██╗
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═════╝ ╚═╝${txtreset}
                                                                                

------------------------------------------------------------------------
EOM
)"
