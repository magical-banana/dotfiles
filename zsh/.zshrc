export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export KUBE_EDITOR=vim
export KUBECONFIG=~/.kube/config
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Aliases
alias kcc="kubectl config use-context"
alias py=python3

# SSH

# Themes Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

