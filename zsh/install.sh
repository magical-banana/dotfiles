#!/bin/bash
# ----------------------------------------------------------------------
# ZSH/INSTALL.SH - Install Zsh, Zinit, and Powerlevel10k
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# --- CRITICAL FIX: SOURCE THE UTILITY FILE RELATIVE TO DOTFILES ROOT ---
source "$(dirname "$(realpath "$0")")/util/install.sh"


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

# --- 2. Powerlevel10k Installation ---
echo "--- Zsh Module: Installing Powerlevel10k theme ---"
P10K_DIR="$HOME/.zinit/themes/powerlevel10k"

if [ ! -d "$P10K_DIR" ]; then
    echo "Cloning Powerlevel10k theme to $P10K_DIR..."
    mkdir -p "$P10K_DIR"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k is already installed."
fi