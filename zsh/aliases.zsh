# Shortcuts
alias vim="nvim"
alias cl="clear;clear"

# Git
alias gc="git commit -S -v -s"
alias gs="git status -s -b"
alias gdc="git diff --cached"
alias gco="git checkout"
alias gcb="git checkout -b"
alias glom="git pull origin master --tags"
alias gloh="git pull origin HEAD --tags"
alias grom="git rebase origin/master"
alias gpoh="git push origin HEAD"
alias gbv="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias nah="git reset --hard;git clean -df;"
alias undocommit="git reset HEAD~"
alias undopush="git push -f origin HEAD^:master" # Undo a `git push`
alias master="git checkout master && git pull"
alias dev="git checkout develop && git pull"
alias lg="lazygit"

# Bat
alias cat="bat"

# Laravel
alias a="php artisan"
