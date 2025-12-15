#!/bin/bash
# ----------------------------------------------------------------------
# VIM/INSTALL.SH - Install Vim/NeoVim package, Amix Vimrc, and custom configs
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# --- CRITICAL FIX: SOURCE THE UTILITY FILE RELATIVE TO DOTFILES ROOT ---
# This ensures 'install_packages' is available
source "$(dirname "$(realpath "$0")")/util/install.sh"


echo "--- Vim Module: Installing base packages ---"
# Install vim or neovim based on system preference (assuming this is handled by setup.sh now)
# We can include it here for module-level isolation if needed, but setup.sh already runs it:
# install_packages vim 

# --- 1. Install Amix Awesome Vimrc ---
VIM_RUNTIME="$HOME/.vim_runtime"

echo "--- Vim Module: Installing Amix Awesome Vimrc ---"
if [ ! -d "$VIM_RUNTIME" ]; then
    echo "Cloning Amix Vimrc repository to $VIM_RUNTIME..."
    # Clone the repository
    git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_RUNTIME"
    
    echo "Running Amix Vimrc installer..."
    # Run the custom installer script provided by Amix.
    # This creates the necessary ~/.vimrc file.
    sh "$VIM_RUNTIME/install_awesome_vimrc.sh"
    
else
    echo "Amix Vimrc is already installed."
fi


# --- 2. Link Custom Configuration (Respecting Amix Structure) ---
echo "--- Vim Module: Linking custom configs into ~/.vim_runtime ---"

# The Amix installer requires the custom configuration to be at:
# ~/.vim_runtime/my_configs.vim

# 1. Define the source file path (in your dotfiles repo)
SOURCE_CONFIG="$(dirname "$(realpath "$0")")/vim/my_configs.vim"

# 2. Define the target link path (inside the installed runtime dir)
CUSTOM_VIM_CONFIG="$HOME/.vim_runtime/my_configs.vim"


# Create a symbolic link from your dotfiles repository to the required location.
# -s: creates a symbolic link
# -F: removes the destination path if it is a directory (needed if Amix created a placeholder)
# -f: removes the destination path if it exists and is a file
if [ -L "$CUSTOM_VIM_CONFIG" ]; then
    echo "Existing custom link found. Removing old link..."
    rm "$CUSTOM_VIM_CONFIG"
elif [ -f "$CUSTOM_VIM_CONFIG" ]; then
    echo "Amix placeholder file found. Removing old file..."
    rm "$CUSTOM_VIM_CONFIG"
fi

# Create the new link
ln -s "$SOURCE_CONFIG" "$CUSTOM_VIM_CONFIG"

echo "Successfully linked custom configs to $CUSTOM_VIM_CONFIG."