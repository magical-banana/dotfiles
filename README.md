# 🍌 Banana Dotfiles

> A high-performance, unified development environment themed with **Catppuccin Mocha**.    
> Optimized for Kubernetes, Terraform, and Go development.

## 🌟 The Vision
The goal of this repository is to provide a **frictionless, context-aware workstation**. 
- **Consistency:** If it's a terminal tool, it must use the Catppuccin Mocha palette.
- **Portability:** Use `mise` for tool versioning so the environment is the same on every machine.
- **Speed:** Minimal shell startup time (<20ms) using `zinit` and `p10k` instant-prompt.
- **Visibility:** Your prompt should tell you exactly where you are (K8s, Git, AWS) without you asking.
---

## 🏗 System Architecture

### 🎨 Visual Layer (The "Skin")
- **Theme:** [Catppuccin Mocha](https://catppuccin.com/) applied across Vim, Tmux, FZF, and Zsh.
- **Prompt:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k) configured for high-contrast "Segmented" readability.
- **Typography:** Requires a **Nerd Font** (e.g., JetBrainsMono) for DevOps iconography.

### 🛠 Tooling Layer (The "Engine")
- **Runtime Manager:** [Mise](https://mise.jdx.sh/) manages Go, Python, Node, and DevOps CLIs (kubectl, terraform).
- **Shell:** `zsh` powered by `zinit` for lightweight plugin management.
- **Search:** `fzf` + `ripgrep` + `fd` for unified fuzzy-searching everything.

### 🍱 Module Structure
This repo uses **GNU Stow** for symlink management. Each directory is a standalone module:
- `/zsh`: Shell configurations and P10k theme logic.
- `/vim`: IDE-like experience for YAML, Go, and Terraform.
- `/tmux`: Persistent terminal sessions and window management.
- `/mise`: Global and project-specific tool versions.
- `/git`: Professional workflow aliases and safety defaults.

---

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have a **Nerd Font** installed in your Terminal Emulator (e.g., Windows Terminal, iTerm2, Kitty).

### 2. Installation
```bash
git clone https://github.com/magical-banana/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh

```

### 3. Verification

Run `mise ls` to ensure your runtimes are installed and `source ~/.zshrc` to refresh the UI.

---

## 🛠 Maintenance & Contributions

### Adding New Tools

1. Add the tool to `mise/config.toml`.
2. If it's a TUI tool (like `k9s` or `lazygit`), add a Catppuccin theme file to its respective folder.
3. Update the `setup.sh` if a specific installation script is required.

### Resetting the Environment

If the UI becomes glitchy or you want to start fresh:

```bash
./clean.sh
./setup.sh

```

---

## 📜 Principles for Contributors

1. **Don't break the theme:** Every new tool should be color-synced to Mocha.
2. **Prefer Mise over Brew/APT:** Keep tool versions locked in the repo.
3. **Document the "Why":** Use the module READMEs to explain the workflow, not just the commands.

---
