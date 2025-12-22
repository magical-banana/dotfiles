#!/bin/bash
set -e

# --- Configuration & Paths ---
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="/tmp/banana_backup_$(date +%Y%m%d_%H%M%S)"
CLEAN_ALL=false
TARGET_MODULE=""

# --- 1. Modular Cleanup Logic ---

purge_zsh() {
    # Added explicit hidden files and zinit data
    local PATHS=( "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.local/share/zinit" )
    backup_and_remove "Zsh" "${PATHS[@]}"
    stow -D zsh 2>/dev/null || true
}

purge_vim() {
    # Added .vimrc and common data paths
    local PATHS=( "$HOME/.vimrc" "$HOME/.vim" "$HOME/.config/nvim" "$HOME/.local/share/nvim" )
    backup_and_remove "Vim" "${PATHS[@]}"
}

purge_mise() {
    local PATHS=( "$HOME/.local/share/mise" "$HOME/.cache/mise" )
    backup_and_remove "Mise" "${PATHS[@]}"
    stow -D mise 2>/dev/null || true
}

purge_tmux() {
    local PATHS=( "$HOME/.tmux.conf" "$HOME/.tmux/plugins" )
    backup_and_remove "Tmux" "${PATHS[@]}"
    stow -D tmux 2>/dev/null || true
}

purge_starship() {
    local PATHS=( "$HOME/.config/starship.toml" "$HOME/.cache/starship" )
    backup_and_remove "Starship" "${PATHS[@]}"
    stow -D starship 2>/dev/null || true
}

# --- 2. Robust Helper Functions ---

backup_and_remove() {
    local label=$1
    shift
    local targets=("$@")
    
    echo -e "\n🧹 Purging $label..."
    local module_backup_dir="$BACKUP_DIR/$label"
    mkdir -p "$module_backup_dir"
    
    for item in "${targets[@]}"; do
        if [ -e "$item" ] || [ -L "$item" ]; then
            echo "  -> Backing up: $item"
            # Use -a (archive) to preserve attributes and -R to handle directories/files correctly
            # We copy to the module folder to avoid nested "home/user" structures
            cp -aL "$item" "$module_backup_dir/" 2>/dev/null || true
            rm -rf "$item"
            echo "  -> Removed: $item"
        else
            echo "  -- Skipped (Not found): $item"
        fi
    done
}

show_help() {
    echo "Usage: ./clean.sh [OPTIONS]"
    echo "Options:"
    echo "  --all          Clean everything"
    echo "  --target [mod] Clean specific (zsh|vim|mise|tmux|starship)"
    echo "  --help         Show this help"
}

# --- 3. Argument Parsing ---

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --all) CLEAN_ALL=true ;;
        --target) TARGET_MODULE="$2"; shift ;;
        --help) show_help; exit 0 ;;
        *) echo "Unknown parameter: $1"; show_help; exit 1 ;;
    esac
    shift
done

# --- 4. Main Execution ---

if [ "$CLEAN_ALL" = false ] && [ -z "$TARGET_MODULE" ]; then
    show_help
    exit 1
fi

echo "📂 Backup created at: $BACKUP_DIR"

if [ "$CLEAN_ALL" = true ]; then
    purge_zsh
    purge_vim
    purge_mise
    purge_tmux
    purge_starship
elif [ -n "$TARGET_MODULE" ]; then
    case $TARGET_MODULE in
        zsh) purge_zsh ;;
        vim) purge_vim ;;
        mise) purge_mise ;;
        tmux) purge_tmux ;;
        starship) purge_starship ;;
        *) echo "❌ Unknown module: $TARGET_MODULE"; exit 1 ;;
    esac
fi

# Final broken link sweep
echo -e "\n🔍 Sweeping broken symlinks..."
find ~ -maxdepth 2 -xtype l -delete

echo -e "\n✨ Cleanup complete. Check $BACKUP_DIR to verify your files."