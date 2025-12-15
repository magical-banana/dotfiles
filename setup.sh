#!/bin/bash
# ----------------------------------------------------------------------
# 2. SETUP.SH - The Main Orchestrator
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

DOTFILES_DIR="$(dirname "$(realpath "$0")")"
cd "$DOTFILES_DIR"

# This makes the install_packages function available in THIS script's environment
source "$DOTFILES_DIR/util/install.sh"

echo "--- 1. Installing Core Prerequisites (git and stow) ---"
install_packages git stow

# --- 2. Execute Module Installation Scripts (using 'source' to inherit 'install_packages') ---
echo "--- 2. Executing module-specific installation scripts ---"

for module in */ ; do
    module_name=$(basename "$module")
    INSTALL_SCRIPT="$module_name/install.sh"
    
    if [ -f "$INSTALL_SCRIPT" ]; then
        echo "Running installation for module: $module_name"
        # Source the module script so it inherits the install_packages function
        source "$INSTALL_SCRIPT" 
    else
        echo "Skipping installation for module: $module_name (No install.sh found)"
    fi
done


# --- 3. Deploy Configuration using Stow ---
echo "--- 3. Deploying configurations using GNU Stow ---"

# Find and deploy all directories that contain config files
for module in */ ; do
    module_name=$(basename "$module")
    # Skip the 'util' directory, which is not a Stow module
    if [ "$module_name" == "util" ] || [ "$module_name" == "util/" ]; then
        echo "Skipping non-config utility module: $module_name"
        continue
    fi
    echo "Stowing module: $module_name"
    stow -v -t "$HOME" "$module_name"
done


# --- 4. Final Post-Deployment Steps ---
# Set Zsh as the default shell
if command -v zsh &> /dev/null && [[ "$SHELL" != *"/zsh" ]]; then
    echo "--- 4. Setting Zsh as the default shell (requires password) ---"
    chsh -s "$(which zsh)"
fi

echo "--- ✅ Setup Complete! Your new environment is ready. ---"
echo "--- NOTE: Please reboot your terminal or log in again. ---"