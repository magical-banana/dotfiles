# History settings — atuin (loaded in 80-tools.zsh) takes over Ctrl-R if
# installed, but we keep the native history file as a fallback.
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "$(dirname "$HISTFILE")"

setopt INC_APPEND_HISTORY     # write each command immediately, not on exit
setopt SHARE_HISTORY          # share between concurrent shells
setopt HIST_IGNORE_DUPS       # don't record consecutive duplicates
setopt HIST_IGNORE_SPACE      # commands prefixed with space aren't recorded
setopt HIST_REDUCE_BLANKS     # collapse runs of whitespace
setopt HIST_VERIFY            # `!!` expands without auto-executing
setopt EXTENDED_HISTORY       # record timestamps
