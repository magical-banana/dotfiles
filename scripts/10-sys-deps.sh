#!/usr/bin/env bash
# System packages — only the irreducible bootstrap layer. Anything that mise
# can install (Go, Node, ripgrep, fd, etc.) is handled in 20-mise.sh.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=../lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

log_step "Installing system dependencies for $(detect_os)"

# Common (cross-distro) names. Distro-specific overrides handled below.
common=(zsh curl git vim stow gawk gettext make jq htop tmux tar unzip)

case "$(detect_os)" in
    linux-debian)
        pkg_install "${common[@]}" build-essential libssl-dev xz-utils fontconfig
        ;;
    linux-fedora)
        pkg_install "${common[@]}" gcc openssl-devel xz fontconfig
        ;;
    linux-arch)
        pkg_install "${common[@]}" base-devel openssl xz fontconfig
        ;;
    macos)
        pkg_install "${common[@]}"
        ;;
    *)
        log_warn "Unknown OS — skipping system deps. Install manually: ${common[*]}"
        ;;
esac

# WSL extras: wslu provides `wslview` (used by zshrc.d/70-os-wsl.zsh as $BROWSER).
if is_wsl && is_linux; then
    log_step "Installing WSL utilities (wslu)"
    case "$(detect_os)" in
        linux-debian) pkg_install wslu ;;
        linux-fedora) pkg_install wslu ;;
        # wslu may not be available on Arch repos — log_warn and move on
        *) log_warn "wslu not installed automatically on this distro" ;;
    esac
fi

log_success "System deps complete."
