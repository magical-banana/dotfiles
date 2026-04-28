# Per-machine secrets — API keys, tokens. The file lives outside the repo
# at ~/.config/secrets/env (mode 0600). The bootstrap script seeds it from
# secrets/env.example on first run.

_secrets_file="${XDG_CONFIG_HOME:-$HOME/.config}/secrets/env"

if [[ -f "$_secrets_file" ]]; then
    # Permissions check — anything more permissive than 0600 is a leak risk.
    # `stat -c %a` is GNU; `stat -f %A` is BSD (macOS). Try GNU first.
    _mode=$(stat -c %a "$_secrets_file" 2>/dev/null || stat -f %A "$_secrets_file" 2>/dev/null)
    if [[ -n "$_mode" && "$_mode" != "600" ]]; then
        printf '\033[33m⚠ %s mode is %s (should be 600). Run: chmod 600 %s\033[0m\n' \
            "$_secrets_file" "$_mode" "$_secrets_file" >&2
    fi
    source "$_secrets_file"
    unset _mode
fi
unset _secrets_file
