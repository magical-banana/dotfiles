# 🍌 Banana Dotfiles

> A high-performance, unified development environment themed with **Gotham**.
> Optimized for AI-agent workflows, Kubernetes, Terraform, and Go development.
> Works on native Linux and WSL with a single bootstrap.

## 🌟 The Vision
The goal of this repository is to provide a **frictionless, context-aware workstation**.
- **Consistency:** If it's a terminal tool, it uses the Gotham palette
  (whatyouhide/vim-gotham — deep teal, high contrast, easy on the eyes).
- **Portability:** Native Linux and WSL share one bootstrap path; OS-specific
  behavior is gated at runtime in `~/.zshrc.d/70-os-*.zsh`.
- **Reproducibility:** `mise` pins every runtime + CLI to a verified version
  (see `mise/.config/mise/config.toml`).
- **Agent-ready:** Pre-installed search/diff/git tooling (`rg`, `fd`, `bat`,
  `delta`, `gh`, `jq`, `yq`, `lazygit`) plus structural-code tooling
  (`difft`, `sg`/ast-grep) and a secrets file at `~/.config/secrets/env`
  for `ANTHROPIC_API_KEY` and friends. `~/.zshenv` exposes mise binaries
  to non-interactive subshells so AI agents (Claude Code, aider) find
  every tool without `mise exec --` wrappers.
- **Speed:** Cached `compinit`, `zinit` lazy-loading, and `p10k` instant-prompt.
---

## 🏗 System Architecture

### 🎨 Visual Layer (The "Skin")
- **Theme:** [Gotham](https://github.com/whatyouhide/vim-gotham) applied across vim, tmux, fzf, fzf-tab previews, and delta diffs.
- **Prompt:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — instant-prompt enabled. The shipped `.p10k.zsh` retains its previous palette; run `p10k configure` to regenerate it with Gotham-aligned colors.
- **Typography:** Requires a **Nerd Font** (JetBrainsMono is auto-installed on native Linux; install on the host for WSL/macOS).

### 🛠 Tooling Layer (The "Engine")
- **Runtime Manager:** [Mise](https://mise.jdx.sh/) manages Go, Python, Node, and DevOps CLIs (kubectl, terraform).
- **Shell:** `zsh` powered by `zinit` for lightweight plugin management.
- **Search:** `fzf` + `ripgrep` + `fd` for unified fuzzy-searching everything.

### 🍱 Module Structure
This repo uses **GNU Stow** for symlink management. Each top-level directory mirrors `$HOME` — adding a config means dropping a file at the right path inside the module, not editing an installer.

- `/zsh`     — shell config (`.zshrc` is a thin loader; real logic lives in `.zshrc.d/`; `.zshenv` exposes mise to non-interactive shells)
- `/vim`     — IDE-like editing for YAML, Go, and Terraform
- `/tmux`    — persistent sessions, Gotham status bar
- `/mise`    — pinned runtime + CLI versions
- `/git`     — modern defaults (`zdiff3`, `rerere`, `histogram`), `gh` credential helper
- `/claude`  — global Claude Code config (`~/.claude/CLAUDE.md`, `settings.json`)

### 🔧 Bootstrap Pipeline
- `bootstrap.sh`  — entry point, derives its own location (no hardcoded paths)
- `lib/`          — `log.sh`, `os.sh` (WSL/distro detection), `stow.sh` (safe-stow with backup)
- `scripts/`      — numbered, idempotent step scripts (`10-sys-deps.sh`, `20-mise.sh`, …)
- `doctor.sh`     — read-only health check; verifies symlinks, tools, secrets file mode
- `clean.sh`      — tear down with timestamped backup to `/tmp`

---

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have a **Nerd Font** installed in your Terminal Emulator (e.g., Windows Terminal, iTerm2, Kitty).

### 2. Installation
```bash
git clone https://github.com/magical-banana/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh           # idempotent — safe to re-run
```

The repo location is auto-detected, so you can clone anywhere (e.g., `~/code/dotfiles`) — no `$HOME/dotfiles` requirement.

### 3. Verification

```bash
./doctor.sh              # checks symlinks, tools, git identity, secrets
mise ls                  # confirms runtimes
exec zsh -l              # reload shell
```

### 4. Secrets

Edit `~/.config/secrets/env` (mode 0600, gitignored) to add your `ANTHROPIC_API_KEY`, `GH_TOKEN`, etc. The bootstrap seeds a template on first run.

---

## 🛠 Maintenance & Contributions

### Adding New Tools

1. Add the tool to `mise/.config/mise/config.toml` with a verified version pin.
2. If it's a TUI tool, configure it with the **Gotham palette** (`#0c1014 / #99d1ce / #33859e / #edb443 / #2aa889`).
3. Add a step in `scripts/[NN]-<tool>.sh` only if a non-mise install action is needed.

### Resetting the Environment

If the UI becomes glitchy or you want to start fresh:

```bash
./clean.sh
./setup.sh

```

---

## 📜 Principles for Contributors

1. **Don't break the theme.** Every TUI is color-synced to Gotham. The canonical palette is in `whatyouhide/vim-gotham`; tmux/fzf/delta configs in this repo are the reference for hex codes.
2. **Prefer mise over brew/apt.** Keep tool versions pinned in `mise/.config/mise/config.toml`. System deps (`10-sys-deps.sh`) only install the irreducible bootstrap layer.
3. **No hardcoded paths.** Anything that wants `$HOME/dotfiles` should derive its location from the script. The repo must work from any clone path.
4. **WSL is a first-class citizen.** Test runtime-conditional code (`is_wsl` in `lib/os.sh`, `~/.zshrc.d/70-os-wsl.zsh`) before merging anything that touches clipboard, browser, or fonts.
5. **Document the "why."** Module READMEs explain workflow; comments explain non-obvious constraints.

---
