#!/bin/bash
set -e

FONT_NAME="JetBrainsMono"
# Using the specific tar.xz URL you requested
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
FONT_DIR="$HOME/.local/share/fonts/$FONT_NAME"

echo "⚙️  Setup for $FONT_NAME Nerd Font..."

# --- IDEMPOTENCY CHECK ---
# We check if the directory exists and contains at least one font file
if [ -d "$FONT_DIR" ] && [ "$(ls -A "$FONT_DIR"/*.ttf 2>/dev/null)" ]; then
    echo "✅ $FONT_NAME is already installed. Skipping download."
    echo "ℹ️  NEXT STEPS:"
    echo "1. LINUX NATIVE: Open your Terminal settings and select '$FONT_NAME Nerd Font'."
    echo "2. WSL2 / REMOTE: You MUST install the font on your HOST (Windows/macOS)."
    echo "   - Download: https://github.com/ryanoasis/nerd-fonts/releases/latest"
    echo "   - Install the .ttf files on Windows, then restart your Terminal/VS Code."
    echo "3. VS CODE: Update 'editor.fontFamily' to include '$FONT_NAME Nerd Font'."
    printf '%s\n' '4. Confirm this font is working by running: `echo -e "\uf17c  \uf31b  \uf308  \ue718  \ue70a`' 
    exit 0
fi

echo "ℹ️  $FONT_NAME not found. Downloading from GitHub..."

# Create clean font directory
mkdir -p "$FONT_DIR"

# Download and extract in one go using a pipe to avoid saving the large tarball
# --strip-components=0 keeps the original file structure inside the folder
curl -sSL "$URL" | tar -xJ -C "$FONT_DIR"

# Cleanup: Nerd Font archives often include Windows-specific files we don't need on Linux
rm -f "$FONT_DIR"/*Windows* 2>/dev/null

# Refresh font cache so the system (and Zsh) recognizes the new icons
echo "ℹ️  Refreshing system font cache..."
fc-cache -f

echo "✅ $FONT_NAME Nerd Font installed successfully."
echo "ℹ️  NEXT STEPS:"
echo "1. LINUX NATIVE: Open your Terminal settings and select '$FONT_NAME Nerd Font'."
echo "2. WSL2 / REMOTE: You MUST install the font on your HOST (Windows/macOS)."
echo "   - Download: https://github.com/ryanoasis/nerd-fonts/releases/latest"
echo "   - Install the .ttf files on Windows, then restart your Terminal/VS Code."
echo "3. VS CODE: Update 'editor.fontFamily' to include '$FONT_NAME Nerd Font'."
printf '%s\n' '4. Confirm this font is working by running: `echo -e "\uf17c  \uf31b  \uf308  \ue718  \ue70a\"`'