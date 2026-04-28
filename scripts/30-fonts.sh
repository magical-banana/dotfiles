#!/usr/bin/env bash
# Install JetBrainsMono Nerd Font on native Linux. On WSL or macOS, fonts
# must be installed on the *host* (Windows / macOS) — this script prints
# instructions and exits cleanly.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=../lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

FONT_NAME="JetBrainsMono"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/$FONT_NAME"

print_host_instructions() {
    log_info "Install ${FONT_NAME} Nerd Font on the HOST (the OS your terminal runs on):"
    log_info "  • Download: https://github.com/ryanoasis/nerd-fonts/releases/latest"
    log_info "  • Install the .ttf files via your OS font manager"
    log_info "  • Set your terminal's font to '${FONT_NAME} Nerd Font'"
}

if is_wsl; then
    log_skip "WSL detected — fonts come from the Windows host."
    print_host_instructions
    exit 0
fi

if is_macos; then
    log_step "Installing $FONT_NAME via Homebrew"
    if ! brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
        brew tap homebrew/cask-fonts 2>/dev/null || true
        brew install --cask font-jetbrains-mono-nerd-font
    else
        log_skip "$FONT_NAME already installed via brew"
    fi
    exit 0
fi

# --- Native Linux path ---
if [[ -d "$FONT_DIR" ]] && compgen -G "$FONT_DIR/*.ttf" >/dev/null; then
    log_skip "$FONT_NAME already installed at $FONT_DIR"
else
    log_step "Downloading $FONT_NAME from GitHub"
    mkdir -p "$FONT_DIR"
    curl -fsSL "$URL" | tar -xJ -C "$FONT_DIR"
    rm -f "$FONT_DIR"/*Windows* 2>/dev/null || true
    log_step "Refreshing font cache"
    fc-cache -f
    log_success "$FONT_NAME Nerd Font installed."
fi

log_info "Set your terminal font to '${FONT_NAME} Nerd Font' if you haven't yet."
log_info "Verify with: echo -e \"\\uf17c  \\ue718  \\ue70a\""
