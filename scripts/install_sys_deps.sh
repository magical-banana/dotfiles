#!/bin/bash
echo "⚙️  Setup System Dependencies..."

if [ -f /etc/debian_version ]; then
    PKGS=(zsh curl git vim stow build-essential gettext gawk libssl-dev)
    echo "ℹ️  Debian base detected, the following pkgs will be installed: $PKGS"
    sudo apt-get update
    for pkg in "${PKGS[@]}"; do
        dpkg -s "$pkg" &>/dev/null || sudo apt-get install -y "$pkg"
    done
elif [ -f /etc/fedora-release ]; then
    PKGS=(zsh curl git vim stow gcc gawk make openssl-devel)
    echo "ℹ️  Fedora base detected, the following pkgs will be installed: $PKGS"
    for pkg in "${PKGS[@]}"; do
        rpm -q "$pkg" &>/dev/null || sudo dnf install -y "$pkg"
    done
fi

echo "✅ All System Dependencies have been installed..."