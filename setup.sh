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
run_step "scripts/install_sys_deps.sh"
run_step "scripts/install_mise.sh"

echo "🔄 Refreshing Symlinks..."
cd ~/dotfiles
stow -R git
stow -R zsh
stow -R mise
stow -R starship
stow -R vim

# Install tools in mise/.config/mise/config.toml
mise install -y
mise reshim

# Install modular scripts
echo "🚀 Modulars and dependencies provisioning..."
run_step "scripts/install_zsh.sh"
run_step "scripts/setup_git.sh"
run_step "scripts/setup_vim.sh"

echo "✨ All tools installed and configs synced!"