#!/bin/bash
echo "⚙️  Setup System Dependencies..."

DEBIAN_PKGS=(zsh curl git vim stow gawk gettext make jq htop tmux tar unzip build-essential libssl-dev)
FEDORA_PKGS=(zsh curl git vim stow gawk gettext make jq htop tmux tar unzip xz fontconfig gcc openssl-devel)

if [ -f /etc/debian_version ]; then
    echo "ℹ️  Debian base detected..."
    sudo apt-get update
    for pkg in "${DEBIAN_PKGS[@]}"; do
        dpkg -s "$pkg" &>/dev/null || sudo apt-get install -y "$pkg"
    done
elif [ -f /etc/fedora-release ]; then
    echo "ℹ️  Fedora base detected..."
    for pkg in "${FEDORA_PKGS[@]}"; do
        rpm -q "$pkg" &>/dev/null || sudo dnf install -y "$pkg"
    done
fi

echo "✅ All System Dependencies have been installed..."
