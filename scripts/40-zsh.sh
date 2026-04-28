#!/usr/bin/env bash
# Install zinit and make zsh the default shell.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=../lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# 1. Install zinit
if [[ -d "$ZINIT_HOME" ]]; then
    log_skip "zinit already installed at $ZINIT_HOME"
else
    log_step "Cloning zinit"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 2. Set zsh as the default shell (no sudo — chsh acts on the calling user).
zsh_path="$(command -v zsh || true)"
if [[ -z "$zsh_path" ]]; then
    die "zsh not installed — should have been handled by 10-sys-deps.sh"
fi

current_shell=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)
if [[ "$current_shell" == "$zsh_path" ]]; then
    log_skip "zsh is already the default shell"
else
    # Make sure zsh is in /etc/shells before chsh-ing to it.
    if ! grep -qx "$zsh_path" /etc/shells; then
        log_step "Adding $zsh_path to /etc/shells (requires sudo)"
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi
    log_step "Changing default shell to zsh"
    if chsh -s "$zsh_path" 2>/dev/null; then
        log_success "Default shell set to zsh — log out + back in to apply"
    else
        log_warn "chsh failed (common on WSL/PAM) — set manually with:"
        log_info "  sudo chsh -s $zsh_path $USER"
    fi
fi
