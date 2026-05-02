# Vagrant on WSL — only loads when we're in WSL *and* vagrant is installed.
# Loads AFTER 70-os-wsl.zsh, so the /mnt/c/* PATH strip in that file has
# already run by the time we re-add the VirtualBox directory below.
#
# See https://developer.hashicorp.com/vagrant/docs/other/wsl
[[ -r /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version || return
command -v vagrant &>/dev/null || return

# Lets vagrant reach the Windows host (required for VirtualBox/Hyper-V
# providers; also rewrites VAGRANT_HOME onto a DrvFs path).
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1

# Vagrant shells out to VBoxManage.exe, which lives on the Windows side.
# Only add the path if VirtualBox is actually installed on the host.
vbox_dir='/mnt/c/Program Files/Oracle/VirtualBox'
if [[ -d $vbox_dir && ":$PATH:" != *":$vbox_dir:"* ]]; then
    export PATH="$PATH:$vbox_dir"
fi
unset vbox_dir
