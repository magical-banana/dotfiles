#!/bin/bash

echo "⚙️  Configuring Vim & Plugins..."

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "ℹ️  Installing Vim-Plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "ℹ️  Running PlugInstall..."
vim --not-a-term +PlugInstall +qall

echo "✅ Vim setup complete."