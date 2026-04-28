#!/usr/bin/env bash
# Idempotent dotfiles bootstrap. Safe to re-run.
#
# Usage:
#   ./bootstrap.sh              # full setup
#   ./bootstrap.sh --skip-mise  # skip the long mise-install step
#   ./bootstrap.sh --dry-run    # print what would be done; touch nothing
#
# DOTFILES_ROOT is derived from this script's location, so the repo can be
# cloned anywhere — no hardcoded $HOME/dotfiles assumption.

set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_ROOT

# shellcheck source=lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"
# shellcheck source=lib/stow.sh
source "$DOTFILES_ROOT/lib/stow.sh"

LOG_FILE="${TMPDIR:-/tmp}/dotfiles_install_$(date +%Y%m%d_%H%M%S).log"
SKIP_MISE=0
DRY_RUN=0

# --- arg parsing ---------------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --skip-mise) SKIP_MISE=1 ;;
        --dry-run)   DRY_RUN=1 ;;
        -h|--help)
            sed -n '2,11p' "$0"
            exit 0
            ;;
        *) die "Unknown flag: $arg" ;;
    esac
done

# --- helpers -------------------------------------------------------------
run_step() {
    local script="$DOTFILES_ROOT/scripts/$1"
    [[ -f "$script" ]] || die "Step script missing: $script"
    log_step "Running: scripts/$1"
    if (( DRY_RUN )); then
        log_skip "[dry-run] would execute $script"
        return 0
    fi
    chmod +x "$script"
    # Pipe through indent for visual nesting; preserve the script's exit code.
    if ! "$script" 2>&1 | tee -a "$LOG_FILE" | indent; then
        die "Step failed: $1 — see $LOG_FILE"
    fi
}

# --- main ----------------------------------------------------------------
main() {
    log_header "Bootstrapping dotfiles"
    log_info "Repo:    $DOTFILES_ROOT"
    log_info "OS:      $(detect_os)"
    log_info "WSL:     $(is_wsl && printf yes || printf no)"
    log_info "Logging: $LOG_FILE"

    # 1. System packages first — sudo gates everything else.
    run_step "10-sys-deps.sh"

    # 2. Mise (the meta-tool that installs the rest of the runtimes).
    run_step "20-mise.sh"

    # 3. Symlink the configs. Must happen BEFORE `mise install` so that
    #    ~/.config/mise/config.toml exists.
    log_step "Linking dotfiles via stow"
    if (( DRY_RUN )); then
        log_skip "[dry-run] would stow git zsh mise vim tmux claude"
    else
        stow_modules git zsh mise vim tmux claude
    fi

    # 4. Now mise can read its config and install the pinned toolchain.
    if (( SKIP_MISE )); then
        log_skip "Skipping mise install (--skip-mise)"
    elif (( DRY_RUN )); then
        log_skip "[dry-run] would run: mise install -y"
    else
        log_step "Installing mise tools (this is the long step)"
        # Force bash so zsh-syntax in eval doesn't bite us.
        eval "$(mise activate bash)"
        mise install -y 2>&1 | tee -a "$LOG_FILE" | indent
    fi

    # 5. Remaining provisioning steps. Each one is individually idempotent.
    #    Order matters: zsh before fonts (zinit clone is the bottleneck;
    #    keep it early so it can run while later steps proceed).
    run_step "40-zsh.sh"
    run_step "30-fonts.sh"   # skipped automatically inside script on WSL
    run_step "50-git.sh"
    run_step "60-vim.sh"
    run_step "70-tmux.sh"
    run_step "80-gh.sh"
    run_step "90-claude.sh"

    log_header "Done"
    log_success "Bootstrap complete."
    log_info "Next: open a new terminal, or run 'exec zsh -l' to reload."
    log_info "Verify health with: ./doctor.sh"
}

main "$@"
