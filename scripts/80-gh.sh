#!/usr/bin/env bash
# GitHub CLI is installed by mise (see mise/config.toml). This script just
# nudges the user to authenticate if they haven't already, and installs
# a couple of useful extensions.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=../lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

if ! has_cmd gh; then
    log_warn "gh not on PATH yet — should be installed by mise. Re-run after mise install."
    exit 0
fi

if gh auth status &>/dev/null; then
    log_skip "gh already authenticated"
else
    log_info "Run 'gh auth login' interactively to set up GitHub auth"
    log_info "  • Choose 'GitHub.com', then 'HTTPS', then 'Login with a web browser'"
    log_info "  • This also configures git to use gh as a credential helper"
fi

# Optional: install agent-friendly gh extensions. Add more to GH_EXTENSIONS
# as you adopt them; the loop is idempotent.
log_step "Installing useful gh extensions"
GH_EXTENSIONS=(
    dlvhdr/gh-dash       # interactive PR/issue dashboard
)
for ext in "${GH_EXTENSIONS[@]}"; do
    if gh extension list 2>/dev/null | grep -q "${ext##*/}"; then
        log_skip "gh extension $ext already installed"
    elif gh extension install "$ext" 2>/dev/null; then
        log_success "gh extension: $ext"
    else
        log_warn "Could not install $ext (auth required, or network issue)"
    fi
done
