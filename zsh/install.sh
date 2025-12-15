#!/bin/bash
# ----------------------------------------------------------------------
# ZSH/INSTALL.SH - Install Zsh, Zinit, and Powerlevel10k
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Environment Variable (Assuming the dotfiles repo is always at ~/dotfiles) ---
DOTFILES_DIR="$HOME/dotfiles"

# --- 0. SOURCING UTILITIES (RELIABLE HARDCODED PATH) ---
# This ensures 'install_packages' is available
source "$DOTFILES_DIR/util/install.sh"


echo "--- Zsh Module: Installing base packages ---"
install_packages zsh

# --- 1. Zinit Installation (CORRECT REPO) ---
echo "--- Zsh Module: Installing Zinit (formerly ZI) ---"
ZINIT_HOME="$HOME/.zinit"

if [ ! -d "$ZINIT_HOME" ]; then
    echo "Cloning Zinit repository to $ZINIT_HOME..."
    mkdir -p "$ZINIT_HOME"
    # *** CORRECT REPO URL ***
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 
else
    echo "Zinit is already installed."
fi

# --- Nerd Font Installation (CRITICAL FOR P10K) ---
echo "--- Zsh Module: Installing MesloLGS Nerd Font ---"

if command -v brew &> /dev/null; then
    # Use Homebrew to install the Cask for a high-quality font
    echo "Detected Homebrew. Installing MesloLGS NF via Cask..."
    brew install --cask font-meslo-lg-nerd-font
    
elif command -v wget &> /dev/null && ([ -d /usr/share/fonts ] || [ -d ~/.local/share/fonts ]); then
    # Generic Linux/WSL Manual Install: Download the recommended P10K font
    echo "Detected Linux environment with wget. Installing MesloLGS NF manually..."
    
    # Define installation directory
    FONT_DIR="$HOME/.local/share/fonts/MesloLGS"
    mkdir -p "$FONT_DIR"

    # MesloLGS NF Regular
    wget -qO "$FONT_DIR/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    
    # MesloLGS NF Bold
    wget -qO "$FONT_DIR/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    
    # MesloLGS NF Italic
    wget -qO "$FONT_DIR/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    
    # MesloLGS NF Bold Italic
    wget -qO "$FONT_DIR/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    
    # Update font cache for Linux systems
    if command -v fc-cache &> /dev/null; then
        echo "Updating font cache..."
        fc-cache -f -v > /dev/null
    fi
else
    echo "Skipping Nerd Font installation: Cannot find Homebrew or necessary tools/directories for manual install."
fi

echo "--- NOTE: MesloLGS NF has been installed. Please manually set this as the font in your terminal emulator (e.g., iTerm, Terminal, VS Code). ---"

# --- 2. Powerlevel10k Installation ---
echo "--- Zsh Module: Installing Powerlevel10k theme ---"
# We define the P10K directory relative to the ZINIT_HOME, as Zinit manages it.
P10K_DIR="$HOME/.zinit/themes/powerlevel10k"

if [ ! -d "$P10K_DIR" ]; then
    echo "Cloning Powerlevel10k theme to $P10K_DIR..."
    mkdir -p "$P10K_DIR"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k is already installed."
fi