# ====================================================================
# 1. P10K INSTANT PROMPT (Must be at the top for speed)
# ====================================================================
# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export KUBE_EDITOR=vim
export KUBECONFIG=~/.kube/config
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ZSH_THEME="powerlevel10k/powerlevel10k"

# ====================================================================
# 3. ZINIT PLUGIN CONFIGURATION (Lazy Loading)
# ====================================================================
ZINIT_HOME="$HOME/.zinit"
# *** CORRECT SOURCE PATH ***
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33}Zinit not found. Please run setup.sh.%f"
else
    # The source path changes to be directly inside $ZINIT_HOME
    source "$ZINIT_HOME/zinit.zsh"
fi

# Use zinit to load Powerlevel10k, enabling prompt theming
zinit light "$ZINIT_HOME/themes/powerlevel10k"

# Zsh-Users Plugins (These are full repositories, use zinit light)
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions


# 1. OMZ Core Git Library (needed for many OMZ features/prompts to work)
zinit snippet OMZL::git.zsh

# 2. DevOps & Developer Plugins
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::web-search
zinit snippet OMZP::terraform
zinit snippet OMZP::aws

# Enable history search (ctrl-R) for easier command lookup
bindkey '^R' history-incremental-search-backward

# Recommended Aliases for DevOps Efficiency


source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ====================================================================
# 4. CUSTOM SETTINGS & ALIASES 
# ====================================================================
alias kcc="kubectl config use-context"
alias ll='ls -lha --color=auto'
alias py=python3
[ -f ~/.kubectl_aliases.txt ] && source ~/.kubectl_aliases.txt