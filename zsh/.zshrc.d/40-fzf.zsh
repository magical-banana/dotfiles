# fzf integration. `fzf --zsh` outputs the keybind + completion glue;
# we don't add a manual `bindkey '^R'` because it duplicates that binding.
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# Use ripgrep + fd for default file searches (ignore-aware, skips .git etc.)
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Gotham palette (whatyouhide/vim-gotham). Roles:
#   bg    base0      bg+   base1      fg    base6     fg+   base7
#   hl    orange     hl+   yellow     header cyan     info  base5
#   pointer yellow   marker green     prompt cyan     spinner orange
export FZF_DEFAULT_OPTS="
--height=60% --layout=reverse --border --info=inline
--color=bg:#0c1014,bg+:#11151c,fg:#99d1ce,fg+:#d3ebe9
--color=hl:#d26937,hl+:#edb443,header:#33859e,info:#599cab
--color=pointer:#edb443,marker:#2aa889,prompt:#33859e,spinner:#d26937
--color=border:#091f2e,gutter:#0c1014"

# Ctrl-T preview with bat when available. The `--theme` value picks a
# dark theme that pairs reasonably with Gotham (bat doesn't ship a native
# Gotham theme; see README for installing one).
if command -v bat &>/dev/null; then
    export BAT_THEME="${BAT_THEME:-OneHalfDark}"
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
fi
