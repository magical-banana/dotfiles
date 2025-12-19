#!/bin/bash
echo "📋 Checking System Dependencies..."

if [ -f /etc/debian_version ]; then
    PKGS=(zsh curl git vim stow build-essential gettext libssl-dev)
    sudo apt update
    for pkg in "${PKGS[@]}"; do
        dpkg -s "$pkg" &>/dev/null || sudo apt install -y "$pkg"
    done
elif [ -f /etc/fedora-release ]; then
    PKGS=(zsh curl git stow gcc make openssl-devel)
    for pkg in "${PKGS[@]}"; do
        rpm -q "$pkg" &>/dev/null || sudo dnf install -y "$pkg"
    done
fi