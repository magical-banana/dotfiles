# Optional productivity tools — each guarded by a `command -v` check so this
# file is safe to ship before the tool is installed.

# zoxide — frecency-based `cd`. `z foo` jumps to the most-used dir matching `foo`.
# `zi foo` opens an interactive picker.
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"   # rebind `cd` itself; `cd -` still works
fi

# atuin — sqlite-backed shell history with optional sync. Replaces the default
# Ctrl-R widget with its own searcher. Up-arrow stays as the native zsh
# behavior (--disable-up-arrow).
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# direnv (rare, but if installed: load per-directory env)
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi
