#!/bin/bash
echo "🧹 Starting Dotfiles Cleanup..."

# 1. Unstow Configs (Removes symlinks)
echo "🔗 Removing Symlinks..."
cd ~/dotfiles
stow -D zsh
stow -D mise
stow -D vscode

# 2. Purge Mise Tools & Engine
if command -v mise &> /dev/null; then
    echo "🛠️ Removing Mise-installed tools..."
    # This removes all installed versions of Go, Python, etc.
    rm -rf ~/.local/share/mise/installs
    rm -rf ~/.local/share/mise/shims
    
    # Optional: If you want to remove the Mise binary itself
    # rm -rf ~/.local/share/mise/bin
fi

# 3. Clean Shell Data (Zinit & P10k)
echo "🐚 Purging Zsh plugin data..."
rm -rf ~/.local/share/zinit
rm -rf ~/.cache/p10k-instant-prompt-*
rm -f ~/.p10k.zsh

# 4. Remove VS Code Extensions (Optional)
# This lists all extensions and uninstalls them one by one
if command -v code &> /dev/null; then
    echo "💻 Uninstalling VS Code extensions..."
    code --list-extensions | xargs -L 1 code --uninstall-extension
fi

# 5. Final verification of stray links
echo "🔍 Checking for stray symlinks in home..."
find ~ -maxdepth 1 -xtype l -delete

echo "✅ Cleanup complete. System is now back to (mostly) stock."