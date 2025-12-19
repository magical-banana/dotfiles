#!/bin/bash
set -e

# Path to ensure Mise is visible during the script run
export PATH="$HOME/.local/bin/mise:$PATH"

# Function to run scripts safely
run_step() {
    echo "➡️ Running: $1"
    chmod +x "$1"
    ./"$1"
}

echo "🚀 System Provisioning..."

# Run the modular pieces
run_step "scripts/install_sys_deps.sh"
run_step "scripts/install_mise.sh"
run_step "scripts/install_zsh.sh"

# Final Sync: 'stow -R' (Restow) is the secret to updates.
# It removes old symlinks and adds new ones in one go.
echo "🔄 Refreshing Symlinks..."
cd ~/dotfiles
stow -R zsh
stow -R mise
stow -R starship
echo "✨ All tools installed and configs synced!"