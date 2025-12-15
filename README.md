# Dotfiles

This repository manages my personal configuration files (dotfiles), using **GNU Stow** for symbolic linking.
This setup is optimized for speed, featuring Powerlevel10k for a sleek look, and includes essential plugins for Git, Docker, and Kubernetes.

## Features

- **Zsh:** Primary shell environment.
- **Zinit:** Fast, asynchronous plugin manager for Zsh.
- **Powerlevel10k:** High-performance, highly customizable Zsh prompt theme.
- **GNU Stow:** Used to manage symbolic links from the repository to the `$HOME` directory.
- **DevOps Focus:** Includes essential aliases and auto-completion for `kubectl`, `docker`, `terraform`, and `git`.
- **Nerd Fonts:** Automated installation of MesloLGS NF for proper icon display.

## 🛠️ Installation Guide

This guide assumes your repository is cloned to `~/dotfiles`.

### 1. Clone the Repository

Clone this repository to your home directory.

```bash
git clone https://github.com/magical-banana/dotfiles.git ~/dotfiles
```

### 2\. Run the Setup Script

The `setup.sh` script is the main orchestrator. It handles installing core dependencies (`git`, `stow`, `wget`), installing Zsh and Zinit, installing the recommended Nerd Font, and deploying configurations via Stow.

```bash
cd ~/dotfiles
# Make sure the script is executable
chmod +x setup.sh zsh/install.sh vim/install.sh util/install.sh

# Run the full setup
./setup.sh
```

_Note: The script may require `sudo` privileges to install system packages (like Zsh) via `apt` or `dnf`._

### 3\. Final Step

- **Restart:** Open a new terminal tab/window to complete the Zinit plugin loading.

## 📂 Repository Structure

The repository uses one directory per configuration file or tool (`zsh`, `vim`, etc.), which is the standard structure required by GNU Stow.

```
~/dotfiles/
├── setup.sh                 <-- The main orchestration script to run.
├── README.md                <-- This documentation file.
|
├── util/
│   └── install.sh           <-- Defines the shared 'install_packages' function.
|
├── zsh/
│   ├── install.sh           <-- Installs Zinit, P10k, and Nerd Fonts.
│   ├── .zshrc               <-- Main Zsh config and plugin declarations (Zinit).
│   ├── .zsh-pre-init        <-- Zinit bootstrap file (sourced by .zshrc).
│   └── .p10k.zsh            <-- Your custom Powerlevel10k theme configuration.
|
├── vim/
│   ├── install.sh           <-- Installs Vim/NeoVim package.
│   └── .vimrc               <-- Your Vim configuration.
|
└── ... (Other modules like .gitconfig, .inputrc, etc.)
```

## ⚙️ Key Modules and Configurations

### Zsh and Zinit

The core of the environment relies on the Zinit loading process defined in the `.zshrc` and `.zsh-pre-init` files. Plugins are loaded using `zinit light` or `zinit snippet` for OMZ plugins:

- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- OMZ plugins: `git`, `docker`, `kubectl`, `terraform`, `aws`, etc.

### GNU Stow

When you run `./setup.sh`, the Stow phase executes commands like:

```bash
stow -t $HOME zsh
stow -t $HOME vim
# ... and so on
```

This creates symbolic links from your repository into your `$HOME` directory, such as:

```
~/.zshrc  ->  ~/dotfiles/zsh/.zshrc
```

---

Happy Hacking\!
