#!/usr/bin/env bash
# Tear down dotfiles state — unstow modules and remove their data dirs.
# Always backs up first to /tmp; nothing is irrecoverable.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=lib/stow.sh
source "$DOTFILES_ROOT/lib/stow.sh"

BACKUP_DIR="${TMPDIR:-/tmp}/dotfiles_clean_backup_$(date +%Y%m%d_%H%M%S)"
CLEAN_ALL=false
TARGET_MODULE=""

show_help() {
    cat <<'EOF'
Usage: ./clean.sh [OPTIONS]

  --all              Purge every managed module
  --target MODULE    Purge a single module (zsh|vim|mise|tmux|git|claude)
  -h, --help         Show this help

A timestamped backup is always created in /tmp before anything is deleted.
EOF
}

backup_and_remove() {
    local label="$1"; shift
    local targets=("$@")
    local module_backup="$BACKUP_DIR/$label"

    log_step "Purging $label"
    mkdir -p "$module_backup"

    for item in "${targets[@]}"; do
        if [[ -e "$item" || -L "$item" ]]; then
            log_info "Backing up: $item"
            cp -aL "$item" "$module_backup/" 2>/dev/null || true
            rm -rf "$item"
        else
            log_skip "Not present: $item"
        fi
    done
}

purge_zsh() {
    backup_and_remove zsh \
        "$HOME/.zshrc" \
        "$HOME/.zshrc.d" \
        "$HOME/.p10k.zsh" \
        "${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
    unstow_module zsh
}

purge_vim() {
    backup_and_remove vim \
        "$HOME/.vimrc" \
        "$HOME/.vim"
    unstow_module vim
}

purge_mise() {
    backup_and_remove mise \
        "${XDG_CONFIG_HOME:-$HOME/.config}/mise" \
        "${XDG_DATA_HOME:-$HOME/.local/share}/mise" \
        "${XDG_CACHE_HOME:-$HOME/.cache}/mise"
    unstow_module mise
}

purge_tmux() {
    backup_and_remove tmux \
        "$HOME/.tmux.conf" \
        "$HOME/.tmux"
    unstow_module tmux
}

purge_git() {
    backup_and_remove git \
        "$HOME/.gitconfig" \
        "$HOME/.gitconfig.local"
    unstow_module git
}

purge_claude() {
    backup_and_remove claude \
        "$HOME/.claude/CLAUDE.md" \
        "$HOME/.claude/settings.json"
    unstow_module claude
}

# --- arg parsing ---------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)    CLEAN_ALL=true ;;
        --target) TARGET_MODULE="${2:-}"; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) log_error "Unknown flag: $1"; show_help; exit 1 ;;
    esac
    shift
done

if ! $CLEAN_ALL && [[ -z "$TARGET_MODULE" ]]; then
    show_help
    exit 1
fi

log_info "Backups will go to: $BACKUP_DIR"

if $CLEAN_ALL; then
    purge_zsh
    purge_vim
    purge_mise
    purge_tmux
    purge_git
    purge_claude
else
    case "$TARGET_MODULE" in
        zsh)    purge_zsh ;;
        vim)    purge_vim ;;
        mise)   purge_mise ;;
        tmux)   purge_tmux ;;
        git)    purge_git ;;
        claude) purge_claude ;;
        *) log_error "Unknown module: $TARGET_MODULE"; exit 1 ;;
    esac
fi

log_step "Sweeping broken symlinks under \$HOME"
find "$HOME" -maxdepth 2 -xtype l -delete

log_success "Cleanup complete. Backup at $BACKUP_DIR"
