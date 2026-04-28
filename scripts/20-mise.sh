#!/usr/bin/env bash
# Install mise. Tool installs (the contents of mise/config.toml) happen
# in bootstrap.sh after `stow_modules` runs, so the config file is in place.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=../lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

if has_cmd mise; then
    log_skip "mise already installed: $(mise --version)"
    exit 0
fi

log_step "Installing mise via official installer"
# Pipe-to-shell — accepted because we control the URL and it's the documented
# install path. If you'd prefer a package install, swap to `pkg_install mise`
# on distros where it's packaged.
curl -fsSL https://mise.jdx.dev/install.sh | sh

# Make sure ~/.local/bin is on PATH for the rest of this run, since the
# installer drops the binary there but doesn't modify the current shell.
export PATH="$HOME/.local/bin:$PATH"

if has_cmd mise; then
    log_success "mise installed: $(mise --version)"
else
    die "mise install failed — binary not found on PATH"
fi
