# Zinit + plugins. Plugin order matters:
#   1. compinit must run before any plugin that uses completions
#   2. fzf-tab MUST load before zsh-syntax-highlighting (otherwise fzf-tab's
#      widget wrapping conflicts with the highlighter — manifested as the
#      "fzf tab race condition" we hit on Fedora previously).
#   3. zsh-autosuggestions and zsh-syntax-highlighting load LAST, in that
#      order, per their respective README guidance.

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -f "$ZINIT_HOME/zinit.zsh" ]] || return   # bootstrap hasn't run yet
source "$ZINIT_HOME/zinit.zsh"

# Cache compinit dump for faster startup. -C skips security check on the
# dump file; -d points at a writeable location under XDG.
autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-${ZSH_VERSION}"
mkdir -p "$(dirname "$_zcompdump")"
compinit -C -d "$_zcompdump"
unset _zcompdump

# Prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Tab completion enhancement (must come before the syntax highlighter)
zinit light Aloxaf/fzf-tab

# Oh-my-zsh snippets — lightweight, no full OMZ install
zinit snippet OMZL::git.zsh
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::web-search
zinit snippet OMZP::docker
zinit snippet OMZP::kubectl
zinit snippet OMZP::terraform

# Suggestions and highlighting — LAST, in this order
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# fzf-tab styling — preview file contents with bat, dirs with eza/ls
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza -1 --color=always --icons $realpath 2>/dev/null || ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
    'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null'
zstyle ':completion:*' menu no  # required by fzf-tab
