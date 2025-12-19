#!/bin/bash
echo "🐚 Configuring Shell & Plugins..."

# Change shell to Zsh
[ "$SHELL" != "$(which zsh)" ] && sudo chsh -s $(which zsh) $USER

# Setup Zinit (Plugin Manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Link Zsh configs
cd ~/dotfiles && stow zsh