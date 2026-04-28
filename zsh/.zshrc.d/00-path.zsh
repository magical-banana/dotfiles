# PATH — set once, deduplicated, in priority order.
# Order (highest priority first):
#   ~/.local/bin       → user-installed CLIs (mise installer drops itself here)
#   mise shims         → added by `mise activate` in 10-mise.zsh
#   $GOBIN             → Go-installed binaries
#   system PATH        → distro default
typeset -U path PATH   # zsh: keep only first occurrence of each entry

path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    $path
)

# Go workspace lives under XDG data — mise installs the runtime separately.
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOBIN="$GOPATH/bin"
path=("$GOBIN" $path)

# XDG basics — many tools respect these and put fewer dotfiles in $HOME.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export PATH
