#!/bin/bash

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "📦 Installing Vim-Plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim +PlugInstall +qall