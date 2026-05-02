#!/usr/bin/env bash
# Optional: install Vagrant inside WSL. NOT wired into bootstrap.sh — run
# explicitly when you want VM-based dev environments.
#
# VirtualBox itself is installed on the Windows host, NOT here. Per
# https://developer.hashicorp.com/vagrant/docs/other/wsl:
#   - Vagrant must be installed inside the Linux distro (this script).
#   - VirtualBox must be installed on Windows; vagrant shells out to
#     VBoxManage.exe via /mnt/c/Program Files/Oracle/VirtualBox.
#   - If you also have Vagrant on Windows, the versions MUST match.
#     Easiest is to not install it on Windows at all.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/log.sh
source "$DOTFILES_ROOT/lib/log.sh"
# shellcheck source=../lib/os.sh
source "$DOTFILES_ROOT/lib/os.sh"

is_wsl || die "This script only runs inside WSL."

if has_cmd vagrant; then
    log_skip "vagrant already installed: $(vagrant --version)"
else
    log_step "Installing Vagrant from HashiCorp's official repo"
    case "$(detect_os)" in
        linux-debian)
            sudo install -m 0755 -d /etc/apt/keyrings
            if [[ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]]; then
                curl -fsSL https://apt.releases.hashicorp.com/gpg \
                    | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            fi
            codename="$(. /etc/os-release && echo "${VERSION_CODENAME:-$UBUNTU_CODENAME}")"
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${codename} main" \
                | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
            sudo apt-get update -qq
            sudo apt-get install -y vagrant
            ;;
        linux-fedora)
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
            sudo dnf install -y vagrant
            ;;
        linux-arch)
            pkg_install vagrant
            ;;
        *)
            die "Unsupported OS for automatic Vagrant install: $(detect_os)"
            ;;
    esac
    log_success "Vagrant installed: $(vagrant --version)"
fi

# Sanity-check VirtualBox on the Windows side.
vbox_dir='/mnt/c/Program Files/Oracle/VirtualBox'
if [[ -x "$vbox_dir/VBoxManage.exe" ]]; then
    log_success "VirtualBox detected on Windows host"
else
    log_warn "VirtualBox NOT detected at: $vbox_dir"
    log_info "Install it on the WINDOWS host (not in WSL):"
    log_info "  https://www.virtualbox.org/wiki/Downloads"
    log_info "Then open a new shell — zsh/.zshrc.d/75-vagrant.zsh adds it to PATH automatically."
fi

cat <<'EOF'

Next steps:
  1. (If you skipped it above) install VirtualBox on the Windows host.
  2. Open a new terminal so 75-vagrant.zsh exports VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
     and prepends VirtualBox to PATH.
  3. Verify: vagrant --version  &&  VBoxManage.exe --version
  4. Per HashiCorp's docs: keep Vagrant projects under /mnt/c/... if you
     hit synced-folder permission issues on the Linux (VolFs) side.
EOF
