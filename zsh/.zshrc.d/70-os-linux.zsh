# Linux-only settings. WSL counts as Linux for `uname -s`, but we want
# distinctly-Linux behavior (e.g., real X/Wayland clipboard) only on
# native Linux — so skip when WSL is detected.
[[ -r /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version && return

# Native browser opener — gh, mise upgrade, etc. shell out to $BROWSER.
if   command -v xdg-open &>/dev/null; then export BROWSER='xdg-open'
elif command -v gnome-open &>/dev/null; then export BROWSER='gnome-open'
fi
