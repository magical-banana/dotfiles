#!/usr/bin/env bash
# OS detection + package-manager abstraction.
# Source this AFTER lib/log.sh so log_* helpers are available.

# Detected once, cached. Values: linux-debian | linux-fedora | linux-arch | macos | unknown
_DETECTED_OS=""

detect_os() {
    if [[ -n "$_DETECTED_OS" ]]; then
        printf '%s' "$_DETECTED_OS"
        return
    fi
    case "$(uname -s)" in
        Darwin) _DETECTED_OS="macos" ;;
        Linux)
            if   [[ -f /etc/debian_version ]]; then _DETECTED_OS="linux-debian"
            elif [[ -f /etc/fedora-release ]]; then _DETECTED_OS="linux-fedora"
            elif [[ -f /etc/arch-release   ]]; then _DETECTED_OS="linux-arch"
            else _DETECTED_OS="linux-unknown"
            fi
            ;;
        *) _DETECTED_OS="unknown" ;;
    esac
    printf '%s' "$_DETECTED_OS"
}

# Returns 0 (true) if running inside WSL. Checks /proc/version (most reliable
# on both WSL1 and WSL2) and falls back to $WSL_DISTRO_NAME.
is_wsl() {
    if [[ -r /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version; then
        return 0
    fi
    [[ -n "${WSL_DISTRO_NAME:-}" ]]
}

is_linux()  { [[ "$(detect_os)" == linux-* ]]; }
is_macos()  { [[ "$(detect_os)" == macos    ]]; }

# Install one or more packages using the detected package manager.
# Skips packages already installed (idempotent).
# Usage: pkg_install zsh curl git
pkg_install() {
    local pkgs=("$@")
    [[ ${#pkgs[@]} -eq 0 ]] && return 0

    case "$(detect_os)" in
        linux-debian)
            local missing=()
            for p in "${pkgs[@]}"; do
                dpkg -s "$p" &>/dev/null || missing+=("$p")
            done
            if [[ ${#missing[@]} -gt 0 ]]; then
                log_info "apt-get install: ${missing[*]}"
                sudo apt-get update -qq
                sudo apt-get install -y "${missing[@]}"
            fi
            ;;
        linux-fedora)
            local missing=()
            for p in "${pkgs[@]}"; do
                rpm -q "$p" &>/dev/null || missing+=("$p")
            done
            if [[ ${#missing[@]} -gt 0 ]]; then
                log_info "dnf install: ${missing[*]}"
                sudo dnf install -y "${missing[@]}"
            fi
            ;;
        linux-arch)
            local missing=()
            for p in "${pkgs[@]}"; do
                pacman -Q "$p" &>/dev/null || missing+=("$p")
            done
            if [[ ${#missing[@]} -gt 0 ]]; then
                log_info "pacman -S: ${missing[*]}"
                sudo pacman -S --noconfirm --needed "${missing[@]}"
            fi
            ;;
        macos)
            command -v brew &>/dev/null || die "Homebrew not installed"
            for p in "${pkgs[@]}"; do
                brew list "$p" &>/dev/null || brew install "$p"
            done
            ;;
        *)
            log_warn "Unknown OS — skipping pkg_install for: ${pkgs[*]}"
            ;;
    esac
}

# True if the given binary is on PATH.
has_cmd() { command -v "$1" &>/dev/null; }
