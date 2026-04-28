# ⚡ Mise (Tool Manager) Module

The "Single Source of Truth" for your development environment. This module manages the installation and versioning of runtimes, cloud-native binaries, and CLI utilities using a declarative `config.toml`.



---

## 🛠 Handled Toolchain
Mise ensures that the exact same versions of these tools are used across your WSL2, Linux, and Dev environments.

All version pins live in [`.config/mise/config.toml`](./.config/mise/config.toml) — the single source of truth. Categories tracked there:

- **Runtimes:** Go, Node (LTS), Python, plus `pipx` and `uv` for Python tooling.
- **DevOps stack:** `terraform`, `ansible-core`, `helm`, `kubectl`, `k9s`, `aws-cli`.
- **Agentic CLIs:** `fzf`, `ripgrep`, `fd`, `bat`, `delta`, `gh`, `jq`, `yq`, `zoxide`, `eza`, `lazygit`, `just`, `xh`, `atuin`.

Versions are bumped deliberately, not on a schedule:
```bash
mise outdated            # show what's behind
mise upgrade <tool>      # bump and update config.toml
```

---

## 🎹 Essential Commands

| Command | Action |
| :--- | :--- |
| `mise ls` | List all tools, active versions, and source config. |
| `mise install` | Install all missing tools defined in `config.toml`. |
| `mise use <tool>@<version>` | Set a specific version for the current directory. |
| `mise upgrade` | Interactive menu to upgrade tools to their latest versions. |
| `mise reshim` | Re-link binaries (run this if a new tool isn't found). |
| `mise doctor` | Check the health of your installation and paths. |

---

## ⚙️ Advanced Configuration Features

### 🔍 Auto-Installation
`not_found_auto_install = true` is enabled. If you type a command for a tool that is listed in the config but not yet installed, Mise will **automatically download and install it** before running the command.

### 🌐 Version File Support
The `node` tool is set to `idiomatic_version_file_enable_tools`. This means Mise will respect `.nvmrc` or `.node-version` files found in specific projects, overriding the global version.

### 🛡️ Experimental Features
`experimental = true` is enabled to support the latest Mise features, including improved task running and environment variable management.

---

## 🔧 Maintenance & Updates
Mise is configured to check for plugin updates every **1 week**. To manually trigger a check:
```bash
mise plugins update
```
**Environment Variables**: Mise automatically loads variables from a .env file in your current directory if it exists (env_file = '.env').