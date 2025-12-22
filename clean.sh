#!/bin/bash
set -e

echo "(Cleaning) Dotfiles..."

# 1. Identify Dotfiles Directory
DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# 2. Unstow Configs
echo "🔗 Removing Symlinks via Stow..."
# Removed 'vim' from the stow list since you want it gone
for folder in zsh mise git; do
    if [ -d "$folder" ]; then
        stow -D "$folder"
    else
        echo "⚠️  Folder $folder not found, skipping."
    fi
done

# 3. Purge Mise Data (Tools & Plugins)
if command -v mise &> /dev/null; then
    echo "🛠️  Purging Mise data..."
    # This removes the vim plugin and all installed vim versions
    mise plugins uninstall vim || true
    rm -rf ~/.local/share/mise
    rm -rf ~/.cache/mise
fi

# 4. Deep Clean Vim & Plugins
echo "📝 Purging Vim configuration and plugins..."
# Remove standard config files
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.viminfo

# Remove Neovim/Vim modern data paths (where plugins often live)
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.config/nvim

# Remove Vim-Plug or other plugin manager data
rm -rf ~/.vim/bundle
rm -rf ~/.vim/autoload

# 5. Clean Shell & Starship Data
echo "🐚 Purging Shell & Prompt data..."
rm -rf ~/.local/share/zinit
rm -rf ~/.cache/p10k-instant-prompt-*
rm -f ~/.p10k.zsh
rm -f ~/.zshrc
rm -rf ~/.cache/starship

# 6. Remove VS Code Extensions
if command -v code &> /dev/null; then
    echo "💻 Uninstalling VS Code extensions..."
    code --list-extensions 2>/dev/null | xargs -I {} code --uninstall-extension {}
fi

# 7. Final verification
echo "🔍 Deleting broken symlinks in home..."
find ~ -maxdepth 2 -xtype l -delete

echo "✅ Cleanup complete. Vim and all tools have been removed."