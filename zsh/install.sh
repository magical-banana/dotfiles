#!/bin/bash
# ----------------------------------------------------------------------
# ZSH/INSTALL.SH - Install Zsh, Oh My Zsh, and Powerlevel10k
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# This makes the install_packages function available
source "$(dirname "$(realpath "$0")")/util/install.sh"


echo "--- Zsh Module: Installing base packages ---"
install_packages zsh

echo "--- Zsh Module: Installing Oh My Zsh and Powerlevel10k ---"

OMZ_DIR="$HOME/.oh-my-zsh"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# 1. Install Oh My Zsh
if [ ! -d "$OMZ_DIR" ]; then
    echo "Cloning Oh My Zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
else
    echo "Oh My Zsh is already installed."
fi

# 2. Install Powerlevel10k theme
if [ ! -d "$P10K_DIR" ]; then
    echo "Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k is already installed."
fi