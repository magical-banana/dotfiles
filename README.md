# 🍌 Banana Dotfiles

**Modular | Idempotent | DevOps-Focused**

A "one-command" setup for a professional DevOps environment on Linux (Ubuntu/Fedora) and WSL2. This repository manages system dependencies, cloud-native binaries, and a unified shell experience, optimized for use with **VS Code**.

---

## 🏗️ Architecture

The repo is split into modular scripts to ensure that installation is "all or nothing" and safe to run multiple times.

- **Engine:** [Mise-en-place](https://mise.jdx.dev/) (Tool version management)
- **Shell:** Zsh + [Zinit](https://github.com/zdharma-continuum/zinit) (High-speed plugin management)
- **Prompt:** Powerlevel10k (Visual context for K8s/Git)
- **Symlinks:** GNU Stow
- **Editor:** VS Code (configured to use Mise shims)

---

## 🚀 Quick Start (Fresh Install)

On a brand new Linux or WSL2 instance, run the following:

```bash
git clone https://github.com/your-username/banana-dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh

```

### What happens under the hood?

1. **`install_sys_deps.sh`**: Detects OS (Apt/Dnf) and installs `git`, `curl`, `stow`, and `build-essential`.
2. **`install_mise.sh`**: Bootstraps the Mise engine and installs **Go, Python, Terraform, Kubectl, Helm, and K9s**.
3. **`install_zsh.sh`**: Changes default shell to Zsh and bootstraps Zinit with P10k.
4. **`stow`**: Symlinks all configs into your `$HOME` directory.

---

## 🛠️ Included Tools

Managed via `mise/config.toml`:

| Tool          | Purpose                      | Source        |
| ------------- | ---------------------------- | ------------- |
| **Kubectl**   | K8s Cluster Management       | Mise (Latest) |
| **Terraform** | IaC (Infrastructure as Code) | Mise (Latest) |
| **K9s**       | Full-screen K8s TUI          | Mise (Latest) |
| **Go**        | Backend Development          | Mise (Latest) |
| **FZF**       | Fuzzy Finder for CLI         | Mise (Latest) |
| **Ripgrep**   | Ultra-fast search            | Mise (Latest) |

---

## 📁 Repository Structure

```text
.
├── scripts/           # The "Brains": Modular bash scripts
│   ├── install_sys_deps.sh
│   ├── install_mise.sh
│   └── install_zsh.sh
├── zsh/               # Zshrc, P10k, and DevOps aliases
├── mise/              # Global tool versions (config.toml)
├── starship/          # Cross-shell prompt config
├── vscode/            # IDE settings and extension lists
├── setup.sh           # Main entry point
└── cleanup.sh         # The "Nuke" script

```

---

## 🧹 Maintenance

**To update your tools and configs:**
Simply pull the latest changes and run the setup again. It will only update what is missing.

```bash
./setup.sh

```

**To remove the setup:**

```bash
./scripts/cleanup.sh

```

---

## 💡 VS Code Integration

To make VS Code use your Mise-managed tools, ensure the **Mise extension** is installed and your `settings.json` points to the shims:
`"go.alternateTools": { "go": "~/.local/share/mise/shims/go" }`
