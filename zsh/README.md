# 🐚 Zsh & Shell Module

A "Turbo-charged" Zsh environment managed by **Zinit**, featuring **Mise** integration and **Powerlevel10k** for DevOps-focused visual context.

---

## 🏎️ Core Performance Features
* **Zinit Manager:** Plugins are loaded as "snippets" or "light" modules, ensuring a fast shell startup even with multiple DevOps tools.
* **Instant Prompt:** Powerlevel10k uses an "Instant Prompt" feature to make the shell interactive before all plugins have finished loading.
* **Mise Activation:** Automatically hooks into `mise` to ensure your Go, Python, and Node versions change instantly when you enter a project directory.

---

## ⌨️ Productivity Shortcuts & Search

| Keybind | Action | Description |
| :--- | :--- | :--- |
| `Tab` | **Fzf-Tab** | Replaces standard completion with a fuzzy-searchable list. |
| `Ctrl + r` | **History Search** | Fuzzy search through your last 10,000 commands via `fzf`. |
| `Right Arrow` | **Accept Suggest** | Complete the command based on your history (via `zsh-autosuggestions`). |
| `Esc Esc` | **Sudo** | Double-tap Esc to add `sudo` to the start of the current command. |

---

## 🚀 DevOps Aliases & Snippets
This setup pulls in official OpenZsh (OMZ) plugins for enterprise-grade command completion.

### ☸️ Kubernetes (kubectl)
* `k` -> (Global Alias) `kubectl`
* `kcc` -> `kubectl config use-context` (Quickly switch clusters)
* *Auto-completion included for all kubectl resources.*

### ☁️ Infrastructure & Apps
* `tf` -> `terraform`
* `d` -> `docker`
* `dc` -> `docker-compose`
* `vi` -> `vim` (Linked to your custom Vim config)

### 📂 File Management
* `ll` -> `ls -lha --color=auto` (Long format, hidden files, icons)
* `py` -> `python3`

---

## 🎨 Visual Context (Powerlevel10k)
The prompt is configured to show critical info only when active:
* **Kubernetes:** Displays current Context and Namespace.
* **Git:** Shows Branch name, Dirty state (+/-), and Stashed status.
* **GCP/AWS:** (If enabled) Shows active profile/account.
* **Execution Time:** Shows how long the last command took to run.

---

## ⚙️ Environment Configuration
* **Go Paths:** `GOPATH` is set to `~/.local/share/go` and added to `PATH`.
* **Editor:** `EDITOR` and `KUBE_EDITOR` are set to `vi` to ensure a consistent experience during `git commit` or `kubectl edit`.
* **History:** Persists 10,000 lines to `~/.zsh_history`.

---

## 🔧 Management & Maintenance

**To update your shell plugins:**
```zsh
zinit update --all
```

**To re-configure your prompt look:**
```zsh
p10k configure
```

**Troubleshooting: If a tool installed by mise is not found, the eval "$(mise activate zsh)" line in .zshrc is responsible for fixing the path. Try running mise reshim.**
