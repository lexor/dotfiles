ZSH_THEME="shellder"
plugins=(
  git
  tmux
  zsh-autosuggestions
)

alias vim="nvim"
alias kod="cd ~/code"
alias dev="cd ~/dev"

# Laravel Homestead
function homestead() {
    ( cd ~/Homestead && vagrant $* )
}

# Go
export GOPATH="$HOME/dev/go"
export GOROOT="/usr/local/opt/go/libexec"
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

