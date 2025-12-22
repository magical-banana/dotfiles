#!/bin/bash
set -e

echo "🧹 (Cleaning) Banana Dotfiles & Theming..."

# 1. Identify Dotfiles Directory
DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

# 2. Unstow Configs
# Added 'tmux' and 'starship' back to the list to ensure symlinks are cleared
echo "🔗 Removing Symlinks via GNU Stow..."
for folder in zsh mise git tmux starship; do
    if [ -d "$folder" ]; then
        stow -D "$folder"
    else
        echo "⚠️  Folder $folder not found, skipping."
    fi
done

# 3. Purge Mise Data (Tools & Plugins)
if command -v mise &> /dev/null; then
    echo "🛠️  Purging Mise runtimes and plugins..."
    # Removes installed versions and the internal mise database
    rm -rf ~/.local/share/mise
    rm -rf ~/.cache/mise
fi

# 4. Deep Clean Vim & Theming
echo "📝 Purging Vim/Neovim configuration and plugins..."
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.viminfo
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.config/nvim

# 5. Purge Shell, P10k & Starship
# We clean both Starship and P10k caches to prevent theme clashing on reinstall
echo "🐚 Purging Shell, P10k, and Starship caches..."
rm -rf ~/.local/share/zinit
rm -rf ~/.cache/p10k-instant-prompt-*
rm -f ~/.p10k.zsh
rm -f ~/.zshrc
rm -rf ~/.cache/starship
rm -rf ~/.config/starship.toml # Ensure the config link is gone

# 6. Clean Tmux Plugins
echo "🪟 Purging Tmux plugins (TPM)..."
rm -rf ~/.tmux/plugins

# 7. Final Verification
echo "🔍 Deleting broken symlinks in home directory..."
find ~ -maxdepth 2 -xtype l -delete

echo "✅ Cleanup complete. All Banana modules and Catppuccin themes have been unlinked."