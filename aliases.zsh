# Shortcuts
alias vim="nvim"
alias cl="clear;clear"

# General
alias la='ls -lah'
alias lls='ls -lh --sort=size --reverse'
alias llt='ls -l -snew'

# Edit/Source vim config
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

# Git
alias gc="_git_dbg commit -S -v -s"
alias gs="_git_dbg status -s -b"
alias gd='_git_dbg diff'
alias gpr="_git_dbg pull --rebase"
alias gdc="_git_dbg diff --cached"
alias gpp='_git_dbg push lexor HEAD'
alias gpem='_git_dbg push lexor HEAD'
alias glem='_git_dbg pull lexor HEAD'
alias gfem='_git_dbg fetch lexor'
alias gco="_git_dbg checkout"
alias gcb="_git_dbg checkout -b"
alias glom="_git_dbg pull origin master --tags"
alias gloh="_git_dbg pull origin HEAD --tags"
alias grom="_git_dbg rebase origin/master"
alias gpoh="_git_dbg push origin HEAD"
alias gbv="_git_dbg for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias nah="_git_dbg reset --hard;git clean -df;"
alias undocommit="_git_dbg reset HEAD~"
alias undopush="_git_dbg push -f origin HEAD^:master" # Undo a `git push`
alias master="_git_dbg checkout master && git pull"
alias dev="_git_dbg checkout develop && git pull"
alias cdr='cd $(git rev-parse --show-toplevel)'
alias lg="lazygit"

# Tmux
alias tma='tmux -u attach -t'
alias tmn='tmux -u new -s'

# Bat
alias cat="bat"
