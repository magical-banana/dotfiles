#!/bin/bash
# ----------------------------------------------------------------------
# GIT/INSTALL.SH - Install Git package and enforce local config existence
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Environment Variable (Assuming the dotfiles repo is always at ~/dotfiles) ---
DOTFILES_DIR="$HOME/dotfiles"

# --- 0. SOURCING UTILITIES ---
source "$DOTFILES_DIR/util/install.sh"


echo "--- Git Module: Installing base packages ---"
install_packages git

# --- 1. ENFORCE CREATION OF MACHINE-SPECIFIC LOCAL CONFIG ---

# Define the FINAL Stow target path
LOCAL_CONFIG_FILE="$HOME/.gitconfig.local"

# Check if the file exists and if it contains the required [user] header
if [ ! -f "$LOCAL_CONFIG_FILE" ] || ! grep -q "user" "$LOCAL_CONFIG_FILE"; then
    echo " "
    echo "========================================================================================="
    echo "!!! CRITICAL SETUP FAILURE: GIT IDENTITY REQUIRED !!!"
    echo " "
    echo "To proceed, you MUST define your machine-specific Git identity."
    echo "1. Create the file: $LOCAL_CONFIG_FILE"
    echo "2. Add your unique user.name and user.email to it:"
    
    # Print the required template content
    cat << EOF
[user]
    name = YOUR_UNIQUE_NAME
    email = YOUR_UNIQUE_EMAIL@example.com
EOF
    echo " "
    echo "Once created (and after running Stow/setup), re-run this script."
    echo "========================================================================================="
    exit 1 # Exit with error code 1 to halt the main setup script
fi

echo "--- Git Module: Local identity file ($LOCAL_CONFIG_FILE) found. Proceeding. ---"

echo "--- Git Module: Installation complete. Stow will deploy .gitconfig and .gitconfig.local next. ---"