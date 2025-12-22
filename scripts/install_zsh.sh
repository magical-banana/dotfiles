#!/bin/bash
echo "⚙️  Configuring Shell & Plugins..."

echo "ℹ️  Change shell to Zsh..."
[ "$SHELL" != "$(which zsh)" ] && sudo chsh -s $(which zsh) $USER

echo "ℹ️  Setup Zinit..."
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    echo "ℹ️  ZINIT_HOME not fount, installing zinit to $ZINIT_HOME ..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

echo "✅ Shell & Plugins setup complete."
