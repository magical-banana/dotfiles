# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal dotfiles repository themed with **Gotham** (whatyouhide/vim-gotham) and tuned for AI-agent workflows on Linux + WSL. The full vision lives in `README.md`; the notes below are what isn't obvious from reading the tree.

## Common commands

```bash
./bootstrap.sh                  # Full provision: deps → mise → stow → tools (idempotent)
./bootstrap.sh --dry-run        # Preview without executing
./bootstrap.sh --skip-mise      # Skip the long mise-install step
./doctor.sh                     # Read-only health check
./clean.sh --all                # Tear down (always backs up to /tmp first)
./clean.sh --target zsh         # Purge a single module (zsh|vim|mise|tmux|git|claude)

# Re-link only (after editing module files)
stow -v -R -t "$HOME" -d "$(pwd)" git zsh mise vim tmux claude

# Re-run a single setup step
./scripts/40-zsh.sh             # all step scripts are individually re-runnable
```

`bootstrap.sh` derives `DOTFILES_ROOT` from its own location, so the repo can live anywhere — there's no longer a `~/dotfiles` requirement.

`scripts/50-git.sh` is interactive on first run (prompts for name/email) and seeds `~/.config/secrets/env` from `secrets/env.example`.

## Architecture

### Module = Stow package

Each top-level directory (`zsh/`, `vim/`, `tmux/`, `git/`, `mise/`, `claude/`) is a **GNU Stow package**. The directory layout *inside* a module mirrors `$HOME` — e.g. `zsh/.zshrc` → `~/.zshrc`, `claude/.claude/CLAUDE.md` → `~/.claude/CLAUDE.md`. Adding a dotfile means putting it at the right path inside the module.

`.stow-local-ignore` in each module excludes `README.md` (and `git/.gitconfig.local.example`) from being symlinked. Update it whenever you add a non-config file.

### Three-layer pipeline

1. **`bootstrap.sh`** — orchestrator only. Derives its own location, sources `lib/*.sh`, runs step scripts in numbered order, calls `stow_modules` between mise-install and mise-tool-install (so the config file is in place when mise reads it).
2. **`lib/`** — small library:
   - `log.sh`: colored helpers (`log_step`, `log_skip`, `log_success`, `die`, `indent`)
   - `os.sh`: `detect_os` (linux-debian/fedora/arch/macos), `is_wsl` (checks `/proc/version`), `pkg_install` (multi-distro abstraction), `has_cmd`
   - `stow.sh`: `stow_modules` (safe-stow with conflict backup), `unstow_module`
3. **`scripts/[NN]-*.sh`** — numbered, idempotent. Each starts by re-deriving `DOTFILES_ROOT` from its own location and sourcing `lib/log.sh` + `lib/os.sh`. Order: `10-sys-deps`, `20-mise`, `30-fonts`, `40-zsh`, `50-git`, `60-vim`, `70-tmux`, `80-gh`, `90-claude`.

### zsh `.zshenv` + `.zshrc.d/` drop-in pattern

`~/.zshenv` is sourced by **every** zsh invocation (interactive, login, AND non-interactive `zsh -c '…'`). It does one thing: prepend mise's shims directory to PATH so AI agents (Claude Code, aider, scripts) find every mise-pinned binary without `mise exec --` wrappers. Keep it minimal — heavy work belongs in `.zshrc`.

`~/.zshrc` is a tiny loader that sources `~/.zshrc.d/*.zsh` in lexical order. Files are numbered by stage:

| File | Purpose |
|---|---|
| `00-path.zsh`     | PATH ordering, GOPATH, XDG_* |
| `10-mise.zsh`     | `mise activate zsh` |
| `20-zinit.zsh`    | zinit + plugins (fzf-tab BEFORE syntax-highlighting), cached compinit |
| `30-history.zsh`  | XDG history file, sane setopts |
| `40-fzf.zsh`      | fzf integration, Gotham FZF_DEFAULT_OPTS, BAT_THEME |
| `50-aliases.zsh`  | aliases, `EDITOR=vim` |
| `60-secrets.zsh`  | sources `~/.config/secrets/env`, warns if mode != 0600 |
| `70-os-linux.zsh` | guard: returns early if WSL detected |
| `70-os-wsl.zsh`   | clip.exe clipboard, wslview BROWSER, strip /mnt/c from PATH |
| `80-tools.zsh`    | zoxide, atuin, direnv hooks (each guarded by `command -v`) |
| `99-p10k.zsh`     | sources `~/.p10k.zsh` last |

When suggesting shell-config changes, target a drop-in file, never `~/.zshrc` itself.

### Per-tool plugin managers

- **zsh** → zinit (cloned by `40-zsh.sh`, sourced from `20-zinit.zsh`)
- **vim** → vim-plug (downloaded by `60-vim.sh`, declared in `.vimrc`)
- **tmux** → tpm (cloned by `70-tmux.sh`, declared in `.tmux.conf`)
- **runtimes & most CLIs** → mise, declared in `mise/.config/mise/config.toml`

Critical zinit ordering: **fzf-tab loads BEFORE zsh-syntax-highlighting**. The reverse order causes a documented race condition (was the bug behind commit `5a106c6`).

### Git config split

`git/.gitconfig` is committed and contains shared settings (modern defaults: `zdiff3`, `rerere`, `histogram`, `autocrlf=input`, delta integration, gh credential helper). It `[include]`s `~/.gitconfig.local`, which is per-machine (name, email) and **gitignored** — `50-git.sh` generates it from `.gitconfig.local.example`.

### Secrets

`~/.config/secrets/env` (mode 0600, gitignored, NOT a Stow target — copied verbatim) holds API keys: `ANTHROPIC_API_KEY`, `GH_TOKEN`, etc. Sourced by `60-secrets.zsh`, which warns if the mode is wrong. Template at `secrets/env.example`.

### Theme contract — Gotham

Canonical palette (whatyouhide/vim-gotham):
```
base0  #0c1014  bg              base6  #99d1ce  fg
base1  #11151c  bg-alt          base7  #d3ebe9  fg-bright
base2  #091f2e  ui              red    #c23127  errors
base3  #0a3749  selection       orange #d26937  numbers, hl
base4  #1e6479  accent          yellow #edb443  warning, current
base5  #599cab  fg-accent       blue   #195466  comments
                                cyan   #33859e  types, active
                                green  #2aa889  strings, additions
```

Where each color lives in this repo:
- **vim**: `silent! colorscheme gotham` (after `plug#end()`); plugin is `whatyouhide/vim-gotham`
- **lightline**: `colorscheme: 'gotham'` (vim-gotham ships an autoload theme)
- **tmux**: inline `set -g status-style` etc. in `tmux/.tmux.conf`
- **fzf**: `FZF_DEFAULT_OPTS` in `zsh/.zshrc.d/40-fzf.zsh`
- **fzf-tab previews**: `BAT_THEME` set in `40-fzf.zsh` (currently `OneHalfDark` — closest built-in pair; see "Optional bat theme" below)
- **delta**: `[delta]` block in `git/.gitconfig`, full Gotham hunk/file/+/- styles
- **p10k**: `.p10k.zsh` is left as user-generated; run `p10k configure` to re-pick a Gotham-friendly palette

New tools should add their theme config inside the relevant module, never as a new top-level directory.

#### Optional: native bat Gotham theme
bat doesn't ship a Gotham TextMate theme. To enable one:
```bash
mkdir -p ~/.config/bat/themes
# drop a Gotham.tmTheme into that dir (e.g. from a base16-gotham port)
bat cache --build
# then update both: BAT_THEME=Gotham in 40-fzf.zsh, syntax-theme=Gotham in .gitconfig
```

## Conventions worth knowing

- `clean.sh` always backs up to `/tmp/dotfiles_clean_backup_<timestamp>/<module>/` before deleting. Never add a destructive path to a `purge_*` function without going through `backup_and_remove`.
- Installer scripts use `#!/usr/bin/env bash` + `set -euo pipefail`. They source `lib/log.sh` and `lib/os.sh` for consistent helpers; don't reinvent `echo` patterns.
- `pkg_install` (in `lib/os.sh`) abstracts apt/dnf/pacman/brew. Don't hand-roll distro branches in step scripts — extend `pkg_install` if a new distro is needed.
- mise pins are **verified versions**, not "latest". Bump deliberately (`mise outdated`, then `mise upgrade <tool>`). The pinning policy is in the comments at the top of `mise/.config/mise/config.toml`.
- WSL detection is `/proc/version` containing `microsoft|wsl` — see `is_wsl` in `lib/os.sh`. Use that, not ad-hoc env checks.
- The `ansible` mise pin tracks the **community bundle** (`ansible 13.6.0` ships with `ansible-core 2.20.5`). The mise plugin pip-installs from PyPI's `ansible` package — `2.x.y` is core, `13.x.y` is bundle.
- Tools needing the **cargo backend** (e.g., `tokei`) need a Rust toolchain (`mise use -g rust@latest`). To avoid that dependency, prefer the `ubi:owner/repo` pin syntax which pulls from GitHub Releases.
- mise install hits the **GitHub API** for the aqua backend — without auth you'll hit rate limits at 60/hr. Set `GITHUB_TOKEN="$(gh auth token)"` before running `mise install` if you're installing many tools at once.
