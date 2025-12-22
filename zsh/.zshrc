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
setopt INC_APPEND_HISTORY

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

source <(fzf --zsh)
bindkey '^R' fzf-history-widget 

# Catppuccin Mocha for FZF
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"


# Aliases
alias kcc="kubectl config use-context"
alias ll='ls -lha --color=auto'
alias py='python3'
alias vi='vim'

# P10K Config Source
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

