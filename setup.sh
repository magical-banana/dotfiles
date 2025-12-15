#!/bin/bash
# ----------------------------------------------------------------------
# SETUP.SH - Main Orchestration Script for Dotfiles Deployment
# ----------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# --- ANSI Color Codes ---
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
BOLD='\e[1m'
NC='\e[0m' # No Color

# --- Variables (RELIABLE HARDCODED PATH) ---
DOTFILES_DIR="$HOME/dotfiles"
# Modules that DO NOT use Stow (handled by their install.sh script)
SKIP_STOW_MODULES=("vim" "util") 

# Change to the root of the dotfiles repository
cd "$DOTFILES_DIR"

# --- 1. Sourcing Utilities ---
# This makes the install_packages function available in THIS script's environment
echo -e "\n${YELLOW}${BOLD}--- SECTION 1: SOURCING CORE UTILITIES ---${NC}"
source "$DOTFILES_DIR/util/install.sh"
echo -e "  [${GREEN}INFO${NC}] 'install_packages' function loaded."


# --- 2. Install Core Prerequisites ---
echo -e "\n${YELLOW}${BOLD}--- SECTION 2: INSTALLING CORE PREREQUISITES ---${NC}"
echo -e "  [${BLUE}ACTION${NC}] Installing required packages: ${BOLD}git${NC} and ${BOLD}stow${NC}."
install_packages git stow


# --- 3. Execute Module Installation Scripts ---
echo -e "\n${YELLOW}${BOLD}--- SECTION 3: EXECUTING MODULE INSTALLERS ---${NC}"

# Find all directories at the root level and loop through them
for module in */ ; do
    module_name=$(basename "$module")
    INSTALL_SCRIPT="$module_name/install.sh"
    
    # Exclude the utility module from execution
    if [ "$module_name" == "util" ]; then
        continue
    fi
    
    if [ -f "$INSTALL_SCRIPT" ]; then
        echo -e "  [${BLUE}MODULE${NC}] Starting installation for: ${BOLD}$module_name${NC}"
        # Execute the module script. Using bash is often safer than 'source' here
        # to prevent unexpected variable leakage into the top-level script, 
        # though 'source' works if the module needs functions defined here.
        bash "$INSTALL_SCRIPT"
        echo -e "  [${GREEN}DONE${NC}] Installation complete for ${BOLD}$module_name${NC}."
    else
        echo -e "  [${YELLOW}SKIP${NC}] Skipping module: ${BOLD}$module_name${NC} (No install.sh found)."
    fi
done


# --- 4. Deploy Configuration using Stow ---
echo -e "\n${YELLOW}${BOLD}--- SECTION 4: DEPLOYING CONFIGURATIONS (STOW) ---${NC}"

# We are already in $DOTFILES_DIR from the initial 'cd' command

for module in "$DOTFILES_DIR"/*/ ; do
    module_name=$(basename "$module")
    
    # Check if the module is in our list of modules that skip Stow
    if [[ " ${SKIP_STOW_MODULES[@]} " =~ " ${module_name} " ]]; then
        echo -e "  [${YELLOW}SKIP${NC}] Skipping Stow deployment for ${BOLD}$module_name${NC} (Manual link via install.sh)."
        continue
    fi
    
    # Run Stow
    echo -e "  [${BLUE}STOW${NC}] Deploying module: ${BOLD}$module_name${NC}"
    # The -t "$HOME" flag tells stow where to create the symlinks
    stow -t "$HOME" "$module_name"
    echo -e "    ${GREEN}→${NC} Symlinks created successfully."

done


# --- 5. Final Post-Deployment Steps ---
echo -e "\n${YELLOW}${BOLD}--- SECTION 5: FINAL SYSTEM CONFIGURATION ---${NC}"

# Set Zsh as the default shell
if command -v zsh &> /dev/null; then
    if [[ "$SHELL" != *"/zsh" ]]; then
        echo -e "  [${BLUE}ACTION${NC}] Setting Zsh as the default shell (requires password)..."
        chsh -s "$(which zsh)"
        echo -e "  [${GREEN}DONE${NC}] Zsh set as default. Reboot/re-login required."
    else
        echo -e "  [${GREEN}INFO${NC}] Zsh is already the default shell."
    fi
fi

# --- 6. Neovim Configuration Bridge (CRITICAL FIX) ---
echo -e "\n${YELLOW}${BOLD}--- SECTION 6: NEONVIM CONFIGURATION BRIDGE ---${NC}"

# This step ensures Neovim loads the Amix/Vim configuration.
VIMRC_FILE="$HOME/.vimrc"
NVIM_INIT_DIR="$HOME/.config/nvim"
NVIM_INIT_FILE="$NVIM_INIT_DIR/init.vim"

if [ -f "$VIMRC_FILE" ]; then
    mkdir -p "$NVIM_INIT_DIR"
    
    if [ ! -L "$NVIM_INIT_FILE" ]; then
        echo -e "  [${BLUE}ACTION${NC}] Creating symlink for Neovim to source ~/.vimrc."
        ln -s "$VIMRC_FILE" "$NVIM_INIT_FILE"
        echo -e "  [${GREEN}DONE${NC}] Neovim configured to load Amix/Vim settings."
    else
        echo -e "  [${GREEN}INFO${NC}] Neovim config bridge already exists."
    fi
else
    echo -e "  [${YELLOW}SKIP${NC}] Skipping Neovim bridge: ~/.vimrc not found (Amix installation may have failed)."
fi


echo -e "\n${GREEN}${BOLD}--- ✅ SETUP COMPLETE! ---${NC}"
echo -e "Your environment is ready. Please reboot your terminal or log in again to fully load Zsh/Zinit."