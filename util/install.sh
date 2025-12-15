#!/bin/bash
# ----------------------------------------------------------------------
# UTIL/INSTALL.SH - Shared function for package installation
# This file is sourced by setup.sh and all module install scripts.
# ----------------------------------------------------------------------

# Define the package installation function
install_packages() {
    echo "--- Checking OS and installing packages: $* ---"
    # Check if a package manager is available and use it
    if command -v apt-get &> /dev/null; then
        echo "Detected Debian/Ubuntu/WSL. Using apt-get..."
        sudo apt-get update > /dev/null
        sudo apt-get install -y "$@"
    elif command -v brew &> /dev/null; then
        echo "Detected macOS/Homebrew. Using brew..."
        brew install "$@"
    elif command -v dnf &> /dev/null; then
        echo "Detected Fedora/CentOS. Using dnf..."
        sudo dnf install -y "$@"
    else
        echo "Error: No supported package manager (apt, brew, dnf) found. Skipping package installation."
        return 1
    fi
}