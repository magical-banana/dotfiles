#!/usr/bin/env bash
# Verify the claude/ module stowed correctly. The actual symlinks were
# created by stow_modules in bootstrap.sh — this script just sanity-checks.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"

CLAUDE_DIR="$HOME/.claude"

if [[ ! -d "$CLAUDE_DIR" ]]; then
    log_warn "$CLAUDE_DIR not found — stow may not have run yet"
    exit 0
fi

for f in CLAUDE.md settings.json; do
    if [[ -L "$CLAUDE_DIR/$f" ]]; then
        log_success "$CLAUDE_DIR/$f → $(readlink "$CLAUDE_DIR/$f")"
    else
        log_warn "$CLAUDE_DIR/$f is not a symlink"
    fi
done

log_info "Claude Code is ready. Edit $DOTFILES_ROOT/claude/.claude/CLAUDE.md"
log_info "to update your global agent guidance, then commit."
