#!/bin/bash
echo "🛠️ Configuring Mise & Tools..."

# Install Mise if missing
if ! command -v mise &> /dev/null; then
    curl https://mise.jdx.dev/install.sh | sh
fi

# Link Mise config before installing tools
cd ~/dotfiles && stow mise

# Install all tools from config.toml
$HOME/.local/bin/mise install -y
$HOME/.local/bin/mise reshim