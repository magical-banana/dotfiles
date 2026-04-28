# Activate mise (runtime version manager). Runs early so subsequent files see
# the right Node/Python/Go versions. mise installs itself to ~/.local/bin so
# the PATH stage above is enough for it to be found.
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi
