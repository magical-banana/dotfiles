# P10K Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path & Mise Activation
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate zsh)"

# Golang
export GOPATH="$HOME/.local/share/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Editors
export EDITOR='vi'
export VISUAL='vi'
export KUBE_EDITOR='vi'

# Zinit & Plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "$ZINIT_HOME/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::web-search

# DevOps Snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::docker
zinit snippet OMZP::kubectl
zinit snippet OMZP::terraform

# History & Keybinds
bindkey '^R' history-incremental-search-backward

# Aliases
alias kcc="kubectl config use-context"
alias ll='ls -lha --color=auto'
alias py='python3'
alias vi='vim'
# P10K Config Source
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh