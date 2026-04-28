#!/usr/bin/env bash
# Health check for the dotfiles environment. Read-only; safe to run anytime.
# Exits 0 if everything looks good, 1 if any required check fails.

set -uo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

FAIL=0

# Lookup order for `command -v <tool>`: PATH first, then mise's registry.
# A tool can be mise-installed but missing from the *current* shell's PATH if
# the shell predates `mise install` — without the mise lookup we'd false-alarm.
has_tool() {
    local tool="$1"
    command -v "$tool" &>/dev/null && return 0
    command -v mise &>/dev/null && mise which "$tool" &>/dev/null && return 0
    return 1
}

check() {
    local label="$1" tool="$2"
    if has_tool "$tool"; then
        log_success "$label"
    else
        log_error "$label"
        FAIL=1
    fi
}

check_optional() {
    local label="$1" tool="$2"
    if has_tool "$tool"; then
        log_success "$label"
    else
        log_skip "$label (optional, not installed)"
    fi
}

check_link() {
    local target="$1"
    # A path is "stowed" if either it itself is a symlink, OR a parent
    # directory in its path is a symlink that resolves into the dotfiles
    # repo (stow's "tree folding" links the directory, not each file).
    if [[ -L "$target" ]]; then
        log_success "$target → $(readlink "$target")"
    elif [[ -e "$target" ]] && realpath "$target" 2>/dev/null | grep -q "$DOTFILES_ROOT"; then
        log_success "$target (via parent symlink → $(realpath "$target" | sed "s|$DOTFILES_ROOT|\$DOTFILES_ROOT|"))"
    else
        log_error "$target is not a symlink (or missing)"
        FAIL=1
    fi
}

log_header "Dotfiles doctor"

log_step "Environment"
log_info "OS:      $(detect_os)"
log_info "WSL:     $(is_wsl && printf yes || printf no)"
log_info "Repo:    $DOTFILES_ROOT"
log_info "Shell:   $SHELL"

log_step "Required CLIs"
check "git"   git
check "stow"  stow
check "zsh"   zsh
check "vim"   vim
check "tmux"  tmux
check "curl"  curl
check "mise"  mise

log_step "Agentic toolkit"
check "ripgrep (rg)" rg
check "fd"           fd
check "fzf"          fzf
check "bat"          bat
check "jq"           jq
check "yq"           yq
check "gh"           gh
check_optional "delta"      delta
check_optional "zoxide"     zoxide
check_optional "atuin"      atuin
check_optional "eza"        eza
check_optional "lazygit"    lazygit
check_optional "just"       just
check_optional "xh"         xh

log_step "Code intelligence"
check_optional "difft"      difft
check_optional "ast-grep (sg)" sg
check_optional "hyperfine"  hyperfine
check_optional "watchexec"  watchexec

log_step "System & QoL"
check_optional "btop"       btop
check_optional "dust"       dust
check_optional "tealdeer (tldr)" tealdeer

log_step "Symlinks"
check_link "$HOME/.zshrc"
check_link "$HOME/.gitconfig"
check_link "$HOME/.tmux.conf"
check_link "$HOME/.vimrc"
check_link "$HOME/.config/mise/config.toml"
check_link "$HOME/.claude/CLAUDE.md"
check_link "$HOME/.claude/settings.json"

log_step "Drop-in files"
# -L follows the directory symlink (stow folds .zshrc.d into a single link)
if [[ -d "$HOME/.zshrc.d" ]] || [[ -L "$HOME/.zshrc.d" ]]; then
    count=$(find -L "$HOME/.zshrc.d" -maxdepth 1 -name '*.zsh' | wc -l)
    log_success "$HOME/.zshrc.d/ ($count drop-ins)"
else
    log_error "$HOME/.zshrc.d/ missing"
    FAIL=1
fi

log_step "Secrets file"
secrets="${XDG_CONFIG_HOME:-$HOME/.config}/secrets/env"
if [[ -f "$secrets" ]]; then
    mode=$(stat -c %a "$secrets" 2>/dev/null || stat -f %A "$secrets" 2>/dev/null)
    if [[ "$mode" == "600" ]]; then
        log_success "$secrets (mode 600)"
    else
        log_warn "$secrets exists but mode is $mode (should be 600)"
    fi
else
    log_skip "$secrets (not created — copy from $DOTFILES_ROOT/secrets/env.example)"
fi

log_step "Git identity"
name=$(git config --global user.name  2>/dev/null || true)
email=$(git config --global user.email 2>/dev/null || true)
if [[ -n "$name" && -n "$email" ]]; then
    log_success "git: $name <$email>"
else
    log_warn "git identity not set (run scripts/50-git.sh or edit ~/.gitconfig.local)"
fi

log_step "GitHub CLI auth"
if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        log_success "gh authenticated"
    else
        log_warn "gh installed but not authenticated (run: gh auth login)"
    fi
fi

log_step "Mise tools"
if command -v mise &>/dev/null; then
    miss_count=$(mise ls --missing 2>/dev/null | wc -l)
    if (( miss_count == 0 )); then
        log_success "mise tools all installed"
    else
        log_warn "$miss_count mise tool(s) missing — run: mise install"
    fi
fi

echo
if (( FAIL )); then
    log_error "Doctor found problems above."
    exit 1
fi
log_success "All checks passed."
