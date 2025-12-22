#!/bin/bash

# Exit on error and pipe failures
set -eo pipefail

DOTFILES_ROOT="$HOME/dotfiles"
LOG_FILE="/tmp/dotfiles_install.log"
export PATH="$HOME/.local/bin:$PATH"

# Colors for UI
export BOLD='\033[1;32m'
export BLUE='\033[0;34m'
export RED='\033[0;31m'
export NC='\033[0m'

# Enhanced Run Function
run_step() {
    local script_path="$1"
    echo -e "${BLUE}➡️  Running: $script_path${NC}"
    
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}❌ Error: $script_path not found.${NC}"
        exit 1
    fi

    chmod +x "$script_path"
    
    # Execute and indent, while also logging everything to a file
    ./"$script_path" 2>&1 | tee -a "$LOG_FILE" | sed 's/^/    │ /'
    
    # Check exit code of the script (not the sed command)
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo -e "${RED}❌ Step failed. Check $LOG_FILE for details.${NC}"
        exit 1
    fi
}

# --- Main Setup ---

echo -e "${BOLD}🚀 Starting System Provisioning...${NC}"
export PATH="$HOME/.local/bin/mise:$PATH"

run_step "scripts/install_sys_deps.sh"
run_step "scripts/install_mise.sh"

echo -e "${BOLD}🔄 Refreshing Symlinks...${NC}"
stow -v -R -t "$HOME" -d "$DOTFILES_ROOT" git zsh mise vim tmux 2>&1 | sed 's/^/    │ /'
echo "✅ Symlinks refresh complete." | sed 's/^/    │ /'

# Ensure Mise is ready for the rest of the script
# Force bash shell type to avoid Zsh syntax errors since we are using #!/bin/bash

echo -e "${BOLD}📦 Installing mise's tools...${NC}"
eval "$(mise activate bash)"
mise install -y 2>&1 | sed 's/^/    │ /'

echo -e "\n${BOLD}🚀 Running Modular Scripts...${NC}"
# Keep logic inside the root directory
run_step "scripts/install_fonts.sh"
run_step "scripts/install_zsh.sh"
run_step "scripts/setup_git.sh"
run_step "scripts/setup_vim.sh"
run_step "scripts/install_tmux.sh"

echo -e "${BOLD}✨ Setup Complete!${NC}"
echo -e "${BOLD}✨ Run 'source ~/.zshrc' or open a new terminal to complete the setup${NC}!"
