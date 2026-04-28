#!/usr/bin/env bash
# Install vim-plug and run :PlugInstall headlessly.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"

PLUG_PATH="$HOME/.vim/autoload/plug.vim"

if [[ -f "$PLUG_PATH" ]]; then
    log_skip "vim-plug already installed"
else
    log_step "Installing vim-plug"
    curl -fsSLo "$PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

log_step "Running :PlugInstall (headless)"
# `--not-a-term` keeps vim from refusing to run when stdin isn't a TTY.
vim --not-a-term +PlugInstall +qall

log_success "vim plugins installed."
