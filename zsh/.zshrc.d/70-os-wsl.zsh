# WSL-only settings. Only loads inside WSL.
[[ -r /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version || return

# Open URLs/files via Windows host. `wslview` (from `wslu`) is the canonical
# way; falls back to `cmd.exe /c start` if wslview isn't installed.
if command -v wslview &>/dev/null; then
    export BROWSER='wslview'
else
    # cmd.exe needs a Windows path; the empty title arg ("") is required by `start`.
    wsl_open() { cmd.exe /c start "" "$(wslpath -w "$1" 2>/dev/null || printf '%s' "$1")"; }
    export BROWSER='wsl_open'
fi

# Clipboard — `clip.exe` writes to the Windows clipboard, `powershell.exe` reads.
# Vim's clipboard=unnamedplus needs an actual binary; we expose `pbcopy`/`pbpaste`
# style aliases so command-line workflows are uniform with macOS.
if command -v clip.exe &>/dev/null; then
    alias pbcopy='clip.exe'
    alias pbpaste='powershell.exe -NoProfile -Command Get-Clipboard | tr -d "\r"'
fi

# Windows interop sometimes leaks Windows PATHs (node.exe, python.exe) ahead
# of mise's Linux binaries. Strip any /mnt/c/... entries from PATH so mise
# wins. Comment this out if you actually want Windows binaries first.
path=("${(@)path:#/mnt/c/*}")
export PATH

# DISPLAY for X11 apps (WSLg sets this; for older WSL, point at host)
if [[ -z "${DISPLAY:-}" && ! -d /mnt/wslg ]]; then
    export DISPLAY="$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
fi
