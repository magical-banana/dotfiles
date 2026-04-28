# Aliases & editors. Keep this short — heavy logic belongs in functions.

# Editor — set to `vim` (not `vi`) so child processes that read $EDITOR
# (gh, kubectl, k9s, git on systems without our alias) get the right binary.
export EDITOR='vim'
export VISUAL='vim'
export KUBE_EDITOR='vim'

# Pager
export PAGER='less'
export LESS='-FRX --mouse'

# `ls` → eza if available (icons, git status, tree). Falls back to GNU ls.
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias tree='eza --tree --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -lha --color=auto'
    alias la='ls -lAh --color=auto'
fi

# `cat` → bat (with sensible defaults that don't break piping)
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias bcat='bat'   # full bat with line numbers + decorations
fi

# tealdeer ships its binary as `tealdeer` but the conventional invocation
# is `tldr`. Add the alias only when the binary is present.
command -v tealdeer &>/dev/null && alias tldr='tealdeer'

# Quality-of-life
alias vi='vim'
alias py='python3'
alias kcc='kubectl config use-context'
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias k='kubectl'

# Make destructive ops ask first (only in interactive mode)
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Jump to git repo root
alias cdr='cd "$(git rev-parse --show-toplevel)"'
