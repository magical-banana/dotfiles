#!/bin/bash

echo "⚙️ Setting up tmux..."

# 1. Install TPM if not present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "ℹ️  Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

# 2. Reload tmux environment (if inside tmux) or install plugins silently
echo "📦 Installing tmux plugins..."
$HOME/.tmux/plugins/tpm/bin/install_plugins

echo "✅ Tmux setup complete."