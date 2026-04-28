#!/usr/bin/env bash
# Install TPM (Tmux Plugin Manager) and the plugins listed in ~/.tmux.conf.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    log_skip "tpm already installed"
else
    log_step "Cloning tpm"
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

log_step "Installing tmux plugins"
"$TPM_DIR/bin/install_plugins"

log_success "tmux plugins installed."
