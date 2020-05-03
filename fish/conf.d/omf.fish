# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

source $HOME/.cargo/env

set -x EDITOR vim
set -x GPG_TTY (tty)

# Dotfiles
set -x DOTFILES "$HOME/dev/dotfiles"

# Go
set -x GOPATH "$HOME/dev/go"
set -x -U GOROOT "/usr/local/opt/go/libexec"
set -x -U GOBIN "$GOPATH/bin"
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin
set -x -U GO111MODULE "auto"

# Alias
# Shortcuts
alias g "git"
alias vim "nvim"
alias v "nvim"
alias c "clear"
alias dev "cd ~/dev"

# Git
alias push "git push"
alias gaa "git add ."
alias gp "git pull"
alias gs "git status -sb"
alias ga "git add"
alias gc "git commit -S -v -s"
alias gce "git commit --amend"
alias gstp "git subtree push --prefix"
alias glo "git log --graph --pretty=format:'%C(blue)%h%C(red)%d %C(green)%ar %C(white)%s %C(yellow)(%an)' --abbrev-commit --date=relative"
alias glv "git log | vim -R -" # Populates Vim with git log where I can go to specific hash by pressing <K>
alias glf "git log --follow -p"
alias gco "git checkout"
alias gcb "git checkout -b"
alias nah "git reset --hard;git clean -df;"
alias undocommit "git reset HEAD~"
alias undopush "git push -f origin HEAD^:master" # Undo a `git push`
alias master "git checkout master && git pull"
alias dev "git checkout develop && git pull"

# Exit quick
alias qq "exit"

# Bat
alias cat "bat"

# FZF
set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
