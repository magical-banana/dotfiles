#!/usr/bin/env bash
# Generate ~/.gitconfig.local on first run; also seed ~/.config/secrets/env
# from the template if the user hasn't created it yet.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"

# --- 1. Per-machine git identity ---
EXAMPLE="$DOTFILES_ROOT/git/.gitconfig.local.example"
TARGET="$HOME/.gitconfig.local"

if [[ -f "$TARGET" ]]; then
    log_skip "$TARGET already exists"
else
    [[ -f "$EXAMPLE" ]] || die "Template missing: $EXAMPLE"
    log_step "Setting up git identity (interactive)"
    read -r -p "  Full name:  " git_name
    read -r -p "  Email:      " git_email
    cp "$EXAMPLE" "$TARGET"
    sed -i.bak "s|\[Your Full Name for THIS Machine\]|$git_name|" "$TARGET"
    sed -i.bak "s|\[Your Email for THIS Machine\]|$git_email|"    "$TARGET"
    rm -f "$TARGET.bak"
    log_success "Wrote $TARGET"
fi

# --- 2. Secrets file scaffolding ---
SECRETS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/secrets"
SECRETS_FILE="$SECRETS_DIR/env"
SECRETS_EXAMPLE="$DOTFILES_ROOT/secrets/env.example"

if [[ -f "$SECRETS_FILE" ]]; then
    log_skip "$SECRETS_FILE already exists"
else
    log_step "Seeding $SECRETS_FILE from template"
    mkdir -p "$SECRETS_DIR"
    cp "$SECRETS_EXAMPLE" "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"
    log_info "Edit $SECRETS_FILE to add your API keys (chmod 600 enforced)"
fi
