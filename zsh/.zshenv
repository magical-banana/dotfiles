# ~/.zshenv — sourced by EVERY zsh invocation (interactive, login, AND
# non-interactive scripts / `zsh -c '…'`). Keep this file fast and minimal:
# anything heavy (plugin loading, completion init, theme) belongs in
# ~/.zshrc which is only sourced by interactive shells.
#
# The single job this file does: make `mise`-managed binaries discoverable
# to non-interactive subshells. Without this, AI coding agents and CI
# scripts that spawn `zsh -c '…'` won't find tools like `bat`, `fd`, `gh`
# even though they're installed via mise.

# mise shims live here. `mise activate --shims` produces equivalent output,
# but a direct path prepend skips the shell-out cost on every shell start.
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
    typeset -U path PATH
    path=("$HOME/.local/share/mise/shims" $path)
    export PATH
fi

# Also surface ~/.local/bin (where mise itself, pipx user installs, and
# many small CLIs live) for non-interactive shells.
if [[ -d "$HOME/.local/bin" ]]; then
    typeset -U path PATH
    path=("$HOME/.local/bin" $path)
    export PATH
fi
