# YukiOS Dotfiles

This repository contains my personal dotfiles for a modern Arch-based Wayland desktop and development environment.

It is designed to be modular and reproducible, with an interactive installer for quickly setting up the environment and manual instructions for users who want more control.

## Features

- Hyprland / Niri compositor and layout configurations
- Noctalia components for panels, widgets and lockscreen
- Neovim configuration and plugins
- Zsh configuration, aliases and plugins
- Kitty terminal configuration and helper scripts
- Reproducible package list in `package.txt`
- Interactive installer with logging and dry-run support
- Automatic configuration backup before symlinking dotfiles
- Optional Docker setup
- UFW, Bluetooth and power-profiles-daemon service setup
- Windows PowerShell configuration snippets

<img width="1920" height="1080" alt="Screenshot_2026-10-29_135008" src="https://github.com/user-attachments/assets/775d0fd7-e193-48df-b621-5dfb2fb1fffc" />


| Niri | Hyprland |
| ---  | --- |
| <img width="1920" height="1080" alt="Screenshot_2026-10-29_134806" src="https://github.com/user-attachments/assets/e4825f8a-0ef4-4609-a1bd-77bebfd61877" /> | <img width="1920" height="1080" alt="Screenshot_2026-10-29_134728" src="https://github.com/user-attachments/assets/588f7ce0-12c4-4b9a-b784-2ccf93dce8c1" /> |



## Supported systems

The installer is intended for **Arch-based distributions**, including:

- Arch Linux (Recommended)
- CachyOS (Recommended)
- EndeavourOS
- Garuda Linux
- Manjaro
- Other Arch-based distributions that identify themselves as Arch-based through `/etc/os-release`

The installer will stop automatically on unsupported distributions.

## Automatic install (Recommended)

The installer can be downloaded and run directly from GitHub:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/tiesen243/dotfiles/main/install.sh")
```

The installer collects the configuration choices at the beginning, then runs the installation without asking additional questions.

It currently lets you choose:

- Git username and email
- Hyprland, Niri, both, or no window manager
- Zen Browser, Firefox, Chromium, Google Chrome, Brave, or no browser
- Whether Docker should be installed

Before making changes, the installer displays an installation plan and waits for confirmation.

### Dry run

To test the installer without applying system changes:

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/tiesen243/dotfiles/main/install.sh") --dry-run
```

Dry-run mode goes through the installation flow and prints commands that would be executed without performing the installation.

### Help

```bash
bash <(curl -fsSL "https://raw.githubusercontent.com/tiesen243/dotfiles/main/install.sh") --help
```

## What the installer does

The installer performs the following steps:

1. Checks that the system is Arch-based and that the script is not being run as root.
2. Installs `git` and `base-devel` when required.
3. Installs `yay` if it is not already available.
4. Clones or updates this repository at `~/dotfiles`.
5. Reads packages from `package.txt`.
6. Installs the selected window manager and browser.
7. Installs `zsh` from the package list and sets it as the default shell when available.
8. Backs up existing configuration directories before creating symlinks.
9. Links the dotfiles configuration into `~/.config`.
10. Configures `ZDOTDIR` through `/etc/zsh/zshenv`.
11. Creates `~/.config/git/config.local` using the Git identity provided during setup.
12. Enables SDDM when installed.
13. Configures UFW when installed.
14. Enables Bluetooth when installed.
15. Enables `power-profiles-daemon` when installed.
16. Optionally installs and enables Docker.
17. Writes a timestamped installation log to `~/.local/state/yukios/`.

Existing configuration is backed up to a timestamped directory such as:

```text
~/.config.bak_{timestamp}
```

## Manual installation

If you prefer to inspect and configure everything manually, follow the steps below.

### 1. Install required tools

Install Git and the base development tools:

```bash
sudo pacman -Syu --needed git base-devel
```

Install `yay`:

```bash
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
cd ~
rm -rf ~/yay
```

### 2. Clone the repository

```bash
git clone https://github.com/tiesen243/dotfiles.git ~/dotfiles
```

### 3. Install packages

```bash
yay -S --needed --noconfirm --answerclean All --answerdiff None $(grep -v '^#' ~/dotfiles/package.txt)
```

### 4. Set Zsh as the default shell

```bash
chsh -s "$(command -v zsh)"
```

### 5. Apply configuration

Back up any existing configuration before creating the symlinks:

```bash
mkdir -p ~/.config.bak
mv ~/.config/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lsd,niri,noctalia,nvim,zsh} ~/.config.bak/ 2>/dev/null || true
```

Create the configuration symlinks:

```bash
ln -s ~/dotfiles/{Thunar,btop,fastfetch,git,gtk-3.0,gtk-4.0,hypr,kitty,lsd,niri,noctalia,nvim,zsh} ~/.config
```

Configure `ZDOTDIR`:

```bash
echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zsh/zshenv
```

### 6. Configure Git

Create `~/.config/git/config.local`:

```ini
[user]
    name = your-name
    email = your-email@example.com
```

### 7. Optional services

UFW:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed
sudo ufw logging on
sudo ufw logging low
sudo ufw --force enable
sudo systemctl enable --now ufw.service
```

Bluetooth:

```bash
sudo systemctl enable --now bluetooth.service
```

Power profiles:

```bash
sudo systemctl enable --now power-profiles-daemon.service
```

Docker:

```bash
yay -S --needed --noconfirm docker docker-buildx docker-compose
sudo systemctl enable --now docker.service
sudo usermod -aG docker "$USER"
```

Log out or reboot after adding your user to the `docker` group.

> [!NOTE]
> Some Neovim plugins require Node.js. I recommend installing it through `vite-plus`:
>
> ```bash
> yay -S --needed vite-plus
> vp env install node@lts
> ```

## Windows

Some parts of this repository can also be reused on Windows, particularly the PowerShell and Neovim configuration.

Clone the repository:

```powershell
git clone https://github.com/tiesen243/dotfiles.git $HOME\dotfiles
```

Run Windows Terminal or PowerShell as Administrator when creating symbolic links.

```powershell
Remove-Item -Force -Recurse $HOME\.config\fastfetch
Remove-Item -Force -Recurse $HOME\dotfiles\git
Remove-Item -Force -Recurse $HOME\AppData\Local\nvim
Remove-Item -Force -Recurse $HOME\Documents\WindowsPowerShell

New-Item -ItemType SymbolicLink -Path $HOME\.config\fastfetch -Target $HOME\dotfiles\fastfetch
New-Item -ItemType SymbolicLink -Path $HOME\.config\git -Target $HOME\dotfiles\git
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\nvim -Target $HOME\dotfiles\nvim
New-Item -ItemType SymbolicLink -Path $HOME\Documents\WindowsPowerShell -Target $HOME\dotfiles\powershell
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
