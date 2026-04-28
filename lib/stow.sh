#!/usr/bin/env bash
# Safe stow wrapper. Detects file conflicts (real files where a symlink should
# go), backs them up to a timestamped dir, then re-stows.
# Requires DOTFILES_ROOT to be set, and lib/log.sh to be sourced.

# Backup directory used when conflicts are encountered.
STOW_BACKUP_DIR="${TMPDIR:-/tmp}/dotfiles_stow_backup_$(date +%Y%m%d_%H%M%S)"

# stow_modules MODULE...
# Re-links each Stow module under $DOTFILES_ROOT to $HOME, backing up any
# conflicting real files first.
stow_modules() {
    local modules=("$@")
    local backed_up=0

    has_cmd stow || die "GNU Stow not installed (install via pkg_install)"

    for module in "${modules[@]}"; do
        local module_dir="$DOTFILES_ROOT/$module"
        [[ -d "$module_dir" ]] || { log_warn "Skipping missing module: $module"; continue; }

        # Find conflicts: files in the module that already exist as non-symlinks in $HOME
        while IFS= read -r -d '' src; do
            local rel="${src#$module_dir/}"
            local dst="$HOME/$rel"
            # Skip files that .stow-local-ignore would exclude
            case "$rel" in
                README.md|.stow-local-ignore) continue ;;
            esac
            if [[ -e "$dst" && ! -L "$dst" ]]; then
                # If $dst resolves through a parent symlink into this repo,
                # it's already stowed (a folded-directory child). Backing it
                # up here would `mv` the real file *out* of the repo and
                # corrupt the working tree on every re-run. Skip those.
                local resolved
                resolved="$(readlink -f "$dst" 2>/dev/null || true)"
                if [[ -n "$resolved" && "$resolved" == "$DOTFILES_ROOT/"* ]]; then
                    continue
                fi
                local backup="$STOW_BACKUP_DIR/$module/$rel"
                mkdir -p "$(dirname "$backup")"
                log_warn "Backing up existing $dst → $backup"
                mv "$dst" "$backup"
                backed_up=1
            fi
        done < <(find "$module_dir" -type f -print0)

        log_step "stow: $module"
        stow -v -R -t "$HOME" -d "$DOTFILES_ROOT" "$module" 2>&1 | indent
    done

    if (( backed_up )); then
        log_info "Conflicting files backed up to: $STOW_BACKUP_DIR"
    fi
}

# unstow_module MODULE — remove symlinks for one module without touching backups.
unstow_module() {
    local module="$1"
    has_cmd stow || return 0
    [[ -d "$DOTFILES_ROOT/$module" ]] || return 0
    stow -D -t "$HOME" -d "$DOTFILES_ROOT" "$module" 2>/dev/null || true
}
