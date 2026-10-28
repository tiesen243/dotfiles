#!/usr/bin/env bash

set -Eeuo pipefail

# =========================================================
# YukiOS - Dotfiles Installation Script
# =========================================================

readonly DOTFILES_REPO="https://github.com/tiesen243/dotfiles.git"
readonly DOTFILES_DIR="$HOME/dotfiles"
readonly YAY_DIR="$HOME/yay"
readonly CONFIG_DIR="$HOME/.config"
readonly LOG_DIR="$HOME/.local/state/yukios"

DRY_RUN=false
BACKUP_DIR=""

# =========================================================
# ARCH-BASED DISTRO CHECK
# =========================================================

if [[ ! -f /etc/os-release ]]; then
    printf "ERROR: Cannot detect operating system.\n" >&2
    exit 1
fi

source /etc/os-release

if [[ "${ID_LIKE:-}" != *arch* && "${ID:-}" != "arch" ]]; then
    printf "ERROR: This script only supports Arch-based distributions.\n" >&2
    printf "Detected: %s\n" "${PRETTY_NAME:-unknown}" >&2
    exit 1
fi

# =========================================================
# OPTIONS
# =========================================================

case "${1:-}" in
    "")
        ;;
    --dry-run)
        DRY_RUN=true
        ;;
    -h|--help)
        cat <<EOF
Usage: $0 [OPTION]

Options:
  --dry-run    Simulate the installation without making changes
  -h, --help   Show this help message
EOF
        exit 0
        ;;
    *)
        printf "ERROR: Unknown option: %s\n" "$1" >&2
        printf "Usage: %s [--dry-run]\n" "$0" >&2
        exit 1
        ;;
esac

# =========================================================
# COLORS
# =========================================================

readonly RESET="\033[0m"
readonly BOLD="\033[1m"
readonly DIM="\033[2m"

readonly RED="\033[31m"
readonly GREEN="\033[32m"
readonly YELLOW="\033[33m"
readonly BLUE="\033[34m"
readonly MAGENTA="\033[35m"
readonly CYAN="\033[36m"

# =========================================================
# LOGGING
# =========================================================

mkdir -p "$LOG_DIR"

readonly LOG_FILE="$LOG_DIR/install-$(date '+%Y%m%d_%H%M%S').log"

exec > >(tee -a "$LOG_FILE") 2>&1

timestamp() {
    date '+%H:%M:%S'
}

log_info() {
    printf "${CYAN}[%s]${RESET} ${BLUE}INFO${RESET}  %s\n" "$(timestamp)" "$*"
}

log_success() {
    printf "${CYAN}[%s]${RESET} ${GREEN}OK${RESET}    %s\n" "$(timestamp)" "$*"
}

log_warn() {
    printf "${CYAN}[%s]${RESET} ${YELLOW}WARN${RESET}  %s\n" "$(timestamp)" "$*"
}

log_error() {
    printf "${CYAN}[%s]${RESET} ${RED}ERROR${RESET} %s\n" "$(timestamp)" "$*" >&2
}

section() {
    echo
    printf "${MAGENTA}${BOLD}"
    printf "────────────────────────────────────────────────────────\n"
    printf "  %s\n" "$1"
    printf "────────────────────────────────────────────────────────\n"
    printf "${RESET}"
}

# =========================================================
# COMMAND HELPERS
# =========================================================

run() {
    if "$DRY_RUN"; then
        printf "${YELLOW}[DRY-RUN]${RESET} "
        printf '%q ' "$@"
        printf "\n"
        return 0
    fi

    "$@"
}

on_error() {
    local exit_code=$?
    local line_number=$1

    log_error "Installation failed at line $line_number."
    log_error "Exit code: $exit_code"
    log_error "Log file: $LOG_FILE"

    exit "$exit_code"
}

trap 'on_error $LINENO' ERR

# =========================================================
# HEADER
# =========================================================

clear

printf "${CYAN}${BOLD}"
cat <<'EOF'

  ██╗   ██╗██╗   ██╗██╗  ██╗██╗ ██████╗ ███████╗
  ╚██╗ ██╔╝██║   ██║██║ ██╔╝██║██╔═══██╗██╔════╝
   ╚████╔╝ ██║   ██║█████╔╝ ██║██║   ██║███████╗
    ╚██╔╝  ██║   ██║██╔═██╗ ██║██║   ██║╚════██║
     ██║   ╚██████╔╝██║  ██╗██║╚██████╔╝███████║
     ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚══════╝

EOF
printf "${RESET}"

printf "${DIM}"
printf "       $DOTFILES_REPO\n"
printf "       YukiOS Dotfiles Installer\n"
printf "       ─────────────────────────\n"
printf "${RESET}"

echo

if "$DRY_RUN"; then
    log_warn "DRY-RUN MODE ENABLED — no system changes will be made."
fi

# =========================================================
# SYSTEM CHECK
# =========================================================

section "SYSTEM CHECK"

if [[ $EUID -eq 0 ]]; then
    log_error "Do not run this script as root."
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    log_error "pacman was not found."
    exit 1
fi

log_success "Arch-based distribution detected: ${PRETTY_NAME:-unknown}"
log_success "User: $USER"

# =========================================================
# USER CONFIGURATION
# =========================================================

section "INSTALLATION CONFIGURATION"

# ---------------------------------------------------------
# Git
# ---------------------------------------------------------

printf "Git username [%s]: " "$USER"
read -r git_name
git_name="${git_name:-$USER}"

printf "Git email [$USER@arch.btw]: "
read -r git_email
git_email="${git_email:-$USER@arch.btw}"

# ---------------------------------------------------------
# Window Manager
# ---------------------------------------------------------

echo
printf "${BOLD}Window Manager${RESET}\n"
echo "  1) Hyprland"
echo "  2) Niri"
echo "  3) Both"
echo "  4) None"

read -r -p "Choice [1-4]: " wm_choice

wm_packages=()

case "$wm_choice" in
    1)
        wm_name="Hyprland"
        wm_packages=(
            hyprland
            xdg-desktop-portal-hyprland
        )
        ;;
    2)
        wm_name="Niri"
        wm_packages=(
            niri
            xdg-desktop-portal-gnome
        )
        ;;
    3)
        wm_name="Hyprland + Niri"
        wm_packages=(
            hyprland
            niri
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gnome
        )
        ;;
    4)
        wm_name="None"
        ;;
    *)
        log_error "Invalid window manager choice."
        exit 1
        ;;
esac

# ---------------------------------------------------------
# Browser
# ---------------------------------------------------------

echo
printf "${BOLD}Web Browser${RESET}\n"
echo "  1) Zen Browser"
echo "  2) Firefox"
echo "  3) Chromium"
echo "  4) Google Chrome"
echo "  5) Brave"
echo "  6) Skip"

read -r -p "Choice [1-6]: " browser_choice

browser_packages=()

case "$browser_choice" in
    1)
        browser_name="Zen Browser"
        browser_packages=(zen-browser-bin)
        ;;
    2)
        browser_name="Firefox"
        browser_packages=(firefox)
        ;;
    3)
        browser_name="Chromium"
        browser_packages=(chromium)
        ;;
    4)
        browser_name="Google Chrome"
        browser_packages=(google-chrome)
        ;;
    5)
        browser_name="Brave"
        browser_packages=(brave-bin)
        ;;
    6)
        browser_name="None"
        ;;
    *)
        log_error "Invalid browser choice."
        exit 1
        ;;
esac

# ---------------------------------------------------------
# Docker
# ---------------------------------------------------------

echo
read -r -p "Install Docker? [y/N]: " docker_choice

if [[ "$docker_choice" =~ ^[Yy]$ ]]; then
    install_docker=true
else
    install_docker=false
fi

# =========================================================
# INSTALLATION PLAN
# =========================================================

section "INSTALLATION PLAN"

printf "OS        : %s\n" "${PRETTY_NAME:-unknown}"
printf "Git       : %s <%s>\n" "$git_name" "$git_email"
printf "WM        : %s\n" "$wm_name"
printf "Browser   : %s\n" "$browser_name"
printf "Docker    : %s\n" "$([[ "$install_docker" == true ]] && echo "Yes" || echo "No")"
printf "Dry-run   : %s\n" "$([[ "$DRY_RUN" == true ]] && echo "Yes" || echo "No")"

echo
read -r -p "Press ENTER to start installation, or Ctrl+C to cancel..."

# =========================================================
# SYSTEM REQUIREMENTS
# =========================================================

section "SYSTEM REQUIREMENTS"

if ! command -v git >/dev/null 2>&1; then
    log_info "Installing git and base development tools..."
    run sudo pacman -Syu --needed --noconfirm git base-devel
    log_success "Base development tools are installed."
else
    log_success "Required base tools are already installed."
fi

# =========================================================
# YAY
# =========================================================

section "AUR HELPER — YAY"

if command -v yay >/dev/null 2>&1; then
    log_success "yay is already installed."
else
    log_info "yay is not installed."

    if "$DRY_RUN"; then
        log_info "Would clone yay to: $YAY_DIR"
        log_info "Would build and install yay with makepkg."
    else
        log_info "Installing yay..."

        rm -rf "$YAY_DIR"
        git clone https://aur.archlinux.org/yay.git "$YAY_DIR"

        (
            cd "$YAY_DIR"
            makepkg -si --noconfirm
        )

        rm -rf "$YAY_DIR"

        log_success "yay installed successfully."
    fi
fi

# =========================================================
# DOTFILES
# =========================================================

section "DOTFILES"

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log_info "Dotfiles repository already exists."

    if "$DRY_RUN"; then
        log_info "Would pull latest changes from GitHub."
    else
        log_info "Pulling latest changes..."
        git -C "$DOTFILES_DIR" pull
        log_success "Dotfiles updated."
    fi
elif [[ -e "$DOTFILES_DIR" ]]; then
    log_error "$DOTFILES_DIR exists but is not a Git repository."
    exit 1
else
    if "$DRY_RUN"; then
        log_info "Would clone:"
        log_info "  $DOTFILES_REPO"
        log_info "to:"
        log_info "  $DOTFILES_DIR"
    else
        log_info "Cloning dotfiles repository..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        log_success "Dotfiles cloned successfully."
    fi
fi

# =========================================================
# PACKAGE INSTALLATION
# =========================================================

section "PACKAGE INSTALLATION"

packages=()

if [[ -f "$DOTFILES_DIR/package.txt" ]]; then
    log_info "Reading packages from package.txt..."

    while IFS= read -r package || [[ -n "$package" ]]; do
        package="${package#"${package%%[![:space:]]*}"}"
        package="${package%"${package##*[![:space:]]}"}"

        [[ -z "$package" ]] && continue
        [[ "$package" == \#* ]] && continue

        packages+=("$package")
    done < "$DOTFILES_DIR/package.txt"

    log_info "Found ${#packages[@]} packages."
else
    if "$DRY_RUN"; then
        log_warn "$DOTFILES_DIR/package.txt would be checked after cloning."
    else
        log_warn "$DOTFILES_DIR/package.txt was not found."
    fi
fi

packages+=("${wm_packages[@]}")
packages+=("${browser_packages[@]}")

if (( ${#packages[@]} > 0 )); then
    log_info "Packages selected for installation: ${#packages[@]}"

    run yay \
        -S \
        --needed \
        --noconfirm \
        --answerclean All \
        --answerdiff None \
        "${packages[@]}"

    log_success "Package installation step completed."
else
    log_warn "No packages selected for installation."
fi

# =========================================================
# DEFAULT SHELL
# =========================================================

section "DEFAULT SHELL"

if command -v zsh >/dev/null 2>&1; then
    zsh_path="$(command -v zsh)"
    current_shell="$(getent passwd "$USER" | cut -d: -f7)"

    if [[ "$current_shell" == "$zsh_path" ]]; then
        log_success "zsh is already the default shell."
    elif "$DRY_RUN"; then
        log_info "Would set default shell to: $zsh_path"
    else
        log_info "Setting zsh as the default shell..."
        chsh -s "$zsh_path"
        log_success "Default shell changed to zsh."
    fi
else
    log_warn "zsh is not installed. Skipping shell configuration."
fi

# =========================================================
# CONFIGURATION BACKUP
# =========================================================

section "CONFIGURATION BACKUP"

config_items=(
    Thunar
    btop
    fastfetch
    git
    gtk-3.0
    gtk-4.0
    hypr
    kitty
    lsd
    niri
    noctalia
    nvim
    zsh
)

BACKUP_DIR="$CONFIG_DIR.bak_$(date '+%Y%m%d_%H%M%S')"

existing_configs=()

for item in "${config_items[@]}"; do
    source="$CONFIG_DIR/$item"

    if [[ -e "$source" || -L "$source" ]]; then
        existing_configs+=("$item")
    fi
done

if (( ${#existing_configs[@]} == 0 )); then
    log_info "No existing configuration needs to be backed up."
else
    if "$DRY_RUN"; then
        log_info "Would create backup directory:"
        log_info "  $BACKUP_DIR"

        for item in "${existing_configs[@]}"; do
            log_info "Would backup: ~/.config/$item"
        done
    else
        mkdir -p "$CONFIG_DIR"
        mkdir -p "$BACKUP_DIR"

        for item in "${existing_configs[@]}"; do
            log_info "Backing up: $item"
            mv "$CONFIG_DIR/$item" "$BACKUP_DIR/"
        done

        log_success "Configuration backup completed."
    fi
fi

# =========================================================
# CONFIGURATION SYMLINKS
# =========================================================

section "CONFIGURATION SYMLINKS"

if ! "$DRY_RUN"; then
    mkdir -p "$CONFIG_DIR"
fi

for item in "${config_items[@]}"; do
    source="$DOTFILES_DIR/$item"
    target="$CONFIG_DIR/$item"

    if [[ ! -e "$source" ]]; then
        log_warn "Dotfiles config not found: $item"
        continue
    fi

    if "$DRY_RUN"; then
        log_info "Would link:"
        log_info "  $target -> $source"
    else
        ln -s "$source" "$target"
        log_success "Linked ~/.config/$item"
    fi
done

# =========================================================
# ZSH CONFIGURATION
# =========================================================

section "ZSH CONFIGURATION"

ZSHENV_LINE='export ZDOTDIR="$HOME/.config/zsh"'

if [[ -f /etc/zsh/zshenv ]] &&
   grep -Fxq "$ZSHENV_LINE" /etc/zsh/zshenv; then

    log_success "ZDOTDIR is already configured."

elif "$DRY_RUN"; then

    log_info "Would add to /etc/zsh/zshenv:"
    log_info "  $ZSHENV_LINE"

else

    echo "$ZSHENV_LINE" | sudo tee -a /etc/zsh/zshenv >/dev/null
    log_success "ZDOTDIR configured."

fi

# =========================================================
# GIT LOCAL CONFIG
# =========================================================

section "GIT LOCAL CONFIG"

git_config="$CONFIG_DIR/git/config.local"

if "$DRY_RUN"; then
    log_info "Would write Git configuration:"
    log_info "  $git_config"
    log_info "  name  = $git_name"
    log_info "  email = $git_email"
else
    mkdir -p "$CONFIG_DIR/git"

    cat > "$git_config" <<EOF
[user]
    name = $git_name
    email = $git_email
EOF

    log_success "Git local configuration written."
fi

# =========================================================
# SDDM
# =========================================================

section "SDDM DISPLAY MANAGER"

if command -v sddm >/dev/null 2>&1; then
    if "$DRY_RUN"; then
        log_info "Would enable and start sddm.service."
    else
        sudo systemctl enable --now sddm.service
        log_success "SDDM is enabled and running."
    fi
else
    log_warn "SDDM is not installed. Skipping."
fi

# =========================================================
# UFW FIREWALL
# =========================================================

section "UFW FIREWALL"

if command -v ufw >/dev/null 2>&1; then
    if "$DRY_RUN"; then
        log_info "Would configure UFW:"
        log_info "  Default incoming: deny"
        log_info "  Default outgoing: allow"
        log_info "  Default routed: deny"
        log_info "  Logging: low"
        log_info "  Service: ufw.service"
    else
        log_info "Configuring UFW..."

        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw default deny routed

        sudo ufw logging on
        sudo ufw logging low

        sudo ufw --force enable
        sudo systemctl enable --now ufw.service

        log_success "UFW firewall is enabled and running."
    fi
else
    log_warn "UFW is not installed. Skipping."
fi

# =========================================================
# BLUETOOTH
# =========================================================

section "BLUETOOTH"

if command -v bluetoothctl >/dev/null 2>&1; then
    if "$DRY_RUN"; then
        log_info "Would enable and start bluetooth.service."
    else
        sudo systemctl enable --now bluetooth.service
        log_success "Bluetooth service is enabled and running."
    fi
else
    log_warn "Bluetooth is not installed. Skipping."
fi

# =========================================================
# POWER PROFILES
# =========================================================

section "POWER PROFILES"

if command -v powerprofilesctl >/dev/null 2>&1; then
    if "$DRY_RUN"; then
        log_info "Would enable and start power-profiles-daemon.service."
    else
        sudo systemctl enable --now power-profiles-daemon.service
        log_success "Power Profiles service is enabled and running."
    fi
else
    log_warn "power-profiles-daemon is not installed. Skipping."
fi

# =========================================================
# DOCKER
# =========================================================

section "DOCKER"

if [[ "$install_docker" == true ]]; then
    log_info "Docker selected."

    run yay \
        -S \
        --needed \
        --noconfirm \
        docker \
        docker-buildx \
        docker-compose

    if "$DRY_RUN"; then
        log_info "Would enable and start docker.service."
        log_info "Would add $USER to the docker group."
        log_warn "A logout/reboot would be required for the group change."
    elif command -v docker >/dev/null 2>&1; then
        log_info "Enabling Docker service..."

        sudo systemctl enable --now docker.service

        if id -nG "$USER" | grep -qw docker; then
            log_success "$USER is already in the docker group."
        else
            sudo usermod -aG docker "$USER"
            log_warn "Added $USER to the docker group."
            log_warn "A logout/reboot is required for the group change to take effect."
        fi

        log_success "Docker is installed and running."
    else
        log_warn "Docker installation completed, but the docker command is unavailable."
    fi
else
    log_info "Skipping Docker installation."
fi

# =========================================================
# CLEANUP
# =========================================================

section "CLEANUP"

if "$DRY_RUN"; then
    log_info "Would remove temporary yay build directory if present."
elif [[ -d "$YAY_DIR" ]]; then
    rm -rf "$YAY_DIR"
    log_success "Temporary yay directory removed."
fi

# =========================================================
# SUMMARY
# =========================================================

section "INSTALLATION COMPLETE"

if "$DRY_RUN"; then
    log_success "YukiOS dry-run completed successfully."
    log_warn "No system changes were made."
else
    log_success "YukiOS installation completed successfully."
fi

echo
log_info "Dotfiles : $DOTFILES_DIR"
log_info "Log file : $LOG_FILE"

if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
    log_info "Backup   : $BACKUP_DIR"
fi

echo

printf "${CYAN}${BOLD}"
cat <<'EOF'
╭────────────────────────────────────────────────────────╮
│                                                        │
│   YukiOS installation complete.                        │
│                                                        │
│   Please reboot your system before starting your       │
│   new desktop environment.                             │
│                                                        │
╰────────────────────────────────────────────────────────╯
EOF
printf "${RESET}"

echo
