##############
# BASIC SETUP
##############

typeset -U PATH
autoload colors; colors;

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR=vim
else
  export EDITOR=nvim
fi

#############
## PRIVATE ##
#############
# Include private stuff that's not supposed to show up
# in the dotfiles repo
local private="${HOME}/.zsh.d/private.sh"
if [ -e ${private} ]; then
  . ${private}
fi

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Dont write duplicate entries in the history file.

setopt inc_append_history
setopt share_history

#############
# COMPLETION
#############

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

# Speed up completion init, see: https://htr3n.github.io/2018/07/faster-zsh/
autoload -Uz compinit

if [[ $OSTYPE = darwin* ]]; then
  if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
    compinit
  else
    compinit -C
  fi
else
  compinit
fi

#unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############
# KEY BINDINGS
###############

# Vim Keybindings
bindkey -v

# Open line in Vim by pressing 'v' in Command-Mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Push current line to buffer stack, return to PS1
bindkey "^Q" push-input

# Make up/down arrow put the cursor at the end of the line
# instead of using the vi-mode mappings for these keys
bindkey "\eOA" up-line-or-history
bindkey "\eOB" down-line-or-history
bindkey "\eOC" forward-char
bindkey "\eOD" backward-char

# CTRL-R to search through history
bindkey '^R' history-incremental-search-backward
# CTRL-S to search forward in history
bindkey '^S' history-incremental-search-forward
# Accept the presented search result
bindkey '^Y' accept-search

# Use the arrow keys to search forward/backward through the history,
# using the first word of what's typed in as search word
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Use the same keys as bash for history forward/backward: Ctrl+N/Ctrl+P
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Backspace working the way it should
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char

# Some emacs keybindings won't hurt nobody
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Where should I put you?
bindkey -s '^F' "tmux-sessionizer\n"

#########
# Aliases
#########

case $OSTYPE in
  linux*)
    local aliasfile="${HOME}/.zsh.d/aliases.Linux.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
  darwin*)
    local aliasfile="${HOME}/.zsh.d/aliases.Darwin.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
esac

if type exa &> /dev/null; then
  alias ls=exa
fi

alias lls='ls -lh --sort=size --reverse'
alias llt='ls -lrt'
alias bear='clear && echo "Clear as a bear!"'

alias history='history 1'
alias hs='history | grep '

# Use rsync with ssh and show progress
alias rsyncssh='rsync -Pr --rsh=ssh'

# Edit/Source vim config
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

# git
alias g='git'
alias gst='git status'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
# [c]heck [o]ut
alias co='git checkout'
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]pull request check[o]ut
po() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-1)}' | xargs git checkout
}
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

# tmux
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -s main'

# ceedee dot dot dot
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# fzz and find
alias fizz='fzz find . -iname "*{{}}*"'

# Notes
alias n='vim +Notes' # Opens Vim and calls `:Notes`

# Go
alias got='go test ./...'

alias k='kubectl'

alias -g withcolors="| sed '/PASS/s//$(printf "\033[32mPASS\033[0m")/' | sed '/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'"

export DOTFILES="$HOME/.dotfiles"

# Load custom functions
if [[ -f "$DOTFILES/functions.zsh" ]]; then
	source "$DOTFILES/functions.zsh"
else
	echo >&2 "WARNING: can't load shell functions"
fi


# Load custom aliases
if [[ -f "$DOTFILES/aliases.zsh" ]]; then
	source "$DOTFILES/aliases.zsh"
else
	echo >&2 "WARNING: can't load shell aliases"
fi

##########
# FUNCTIONS
##########

##############
# BASIC SETUP
##############

typeset -U PATH
autoload colors; colors;

#############
## PRIVATE ##
#############
# Include private stuff that's not supposed to show up
# in the dotfiles repo
local private="${HOME}/.zsh.d/private.sh"
if [ -e ${private} ]; then
  . ${private}
fi

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Dont write duplicate entries in the history file.

setopt inc_append_history
setopt share_history

#############
# COMPLETION
#############

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

# Speed up completion init, see: https://htr3n.github.io/2018/07/faster-zsh/
autoload -Uz compinit

if [[ $OSTYPE = darwin* ]]; then
  if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
    compinit
  else
    compinit -C
  fi
else
  compinit
fi

# unsetopt menucomplete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############
# KEY BINDINGS
###############

# Vim Keybindings
bindkey -v

# Open line in Vim by pressing 'v' in Command-Mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Push current line to buffer stack, return to PS1
bindkey "^Q" push-input

# Make up/down arrow put the cursor at the end of the line
# instead of using the vi-mode mappings for these keys
bindkey "\eOA" up-line-or-history
bindkey "\eOB" down-line-or-history
bindkey "\eOC" forward-char
bindkey "\eOD" backward-char

# CTRL-R to search through history
bindkey '^R' history-incremental-search-backward
# CTRL-S to search forward in history
bindkey '^S' history-incremental-search-forward
# Accept the presented search result
bindkey '^Y' accept-search

# Use the arrow keys to search forward/backward through the history,
# using the first word of what's typed in as search word
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Use the same keys as bash for history forward/backward: Ctrl+N/Ctrl+P
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Backspace working the way it should
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char

# Some emacs keybindings won't hurt nobody
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Where should I put you?
bindkey -s '^F' "tmux-sessionizer\n"

#########
# Aliases
#########

case $OSTYPE in
  linux*)
    local aliasfile="${HOME}/.zsh.d/aliases.Linux.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
  darwin*)
    local aliasfile="${HOME}/.zsh.d/aliases.Darwin.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
esac

if type eza &> /dev/null; then
  alias ls=eza
fi
alias lls='ls -lh --sort=size --reverse'
alias llt='ls -l -snew'
alias bear='clear && echo "Clear as a bear!"'

alias history='history 1'
alias hs='history | grep '

# Use rsync with ssh and show progress
alias rsyncssh='rsync -Pr --rsh=ssh'

# Edit/Source vim config
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

# git
alias gst='git status'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
# [c]heck [o]ut
alias co='git checkout'
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]ull request check[o]ut
po() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
}
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

# tmux
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -s main'

# ceedee dot dot dot
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# fzz and find
alias fizz='fzz find . -iname "*{{}}*"'

# Notes
alias n='vim +Notes' # Opens Vim and calls `:Notes`

# Go
alias got='go test ./...'

alias k='kubectl'

alias -g withcolors="| sed '/PASS/s//$(printf "\033[32mPASS\033[0m")/' | sed '/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'"

##########
# FUNCTIONS
##########

mkdircd() {
  mkdir -p $1 && cd $1
}

render_dot() {
  local out="${1}.png"
  dot "${1}" \
    -Tpng \
    -Nfontname='JetBrains Mono' \
    -Nfontsize=10 \
    -Nfontcolor='#fbf1c7' \
    -Ncolor='#fbf1c7' \
    -Efontname='JetBrains Mono' \
    -Efontcolor='#fbf1c7' \
    -Efontsize=10 \
    -Ecolor='#fbf1c7' \
    -Gbgcolor='#1d2021' > ${out} && \
    kitty +kitten icat --align=left ${out}
}


spinner() {
  while
  do
    for i in "-" "\\" "|" "/"
    do
      echo -n " $i \r\r"
      sleep .1
    done
  done
}

# Open PR on GitHub
pr() {
  if type gh &> /dev/null; then
    gh pr view -w
  else
    echo "gh is not installed"
  fi
}

#########
# PROMPT
#########

setopt prompt_subst

git_prompt_info() {
  local dirstatus=" OK"
  local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

  if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
}

# local dir_info_color="$fg_bold[black]"

# This just sets the color to "bold".
# Future me. Try this to see what's correct:
#   $ print -P '%fg_bold[black] black'
#   $ print -P '%B%F{black} black'
#   $ print -P '%B black'
local dir_info_color="%B"

local dir_info_color_file="${HOME}/.zsh.d/dir_info_color"
if [ -r ${dir_info_color_file} ]; then
  source ${dir_info_color_file}
fi

local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"
local promptnormal="φ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

# Show how many nested `nix shell`s we are in
# local nix_prompt=""
# # Set ORIG_SHLVL only if it wasn't previously set and if SHLVL > 1 and
# # GHOSTTY_RESOURCES_DIR is not empty
# if [[ -z $ORIG_SHLVL ]]; then
#   if [[ -z $GHOSTTY_RESOURCES_DIR ]]; then
#     export ORIG_SHLVL=$SHLVL
#   elif  [[ $SHLVL -gt 1 ]]; then
#     export ORIG_SHLVL=$SHLVL
#   fi
# fi;
# # If ORIG_SHLVL is set and SHLVL is now greater: display nesting level
# if [[ ! -z $ORIG_SHLVL && $SHLVL -gt $ORIG_SHLVL ]]; then
#   nix_prompt=("(%F{yellow}$(($SHLVL - $ORIG_SHLVL))%f) ")
# fi;

PROMPT='${dir_info}$(git_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'

simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"
}

########
# ENV
########

kitty_dark_theme="$HOME/.dotfiles/kitty_theme_gruvbox_dark_hard.conf"
kitty_light_theme="$HOME/.dotfiles/kitty_colors_lucius_white_high_contrast.conf"
kitty_theme_symlink="$HOME/.config/kitty/theme.conf"

if [ "$(readlink -- "${kitty_theme_symlink}")" = "${kitty_light_theme}" ];
then
  export KITTY_COLORS="light"
  export GLAMOUR_STYLE=light
else
  export KITTY_COLORS="dark"
  export GLAMOUR_STYLE=dark
fi

set_fzf_default_opts() {
  if [[ $KITTY_COLORS == "light" ]]; then
    export FZF_DEFAULT_OPTS='
    --color=bg+:#DEECF9,bg:#FFFFFF,spinner:#3f5fff,hl:#586e75
    --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#3f5fff
    --color=marker:#3f5fff,fg+:#839496,prompt:#3f5fff,hl+:#3f5fff'
  else
    export FZF_DEFAULT_OPTS=''
  fi
}

set_bat_theme() {
  if [[ $KITTY_COLORS == "light" ]]; then
    export BAT_THEME=ansi
  else
    export BAT_THEME=ansi
  fi
}

toggle_colors() {
  if [[ $KITTY_COLORS == "light" ]]; then
    export KITTY_COLORS="dark"
    ln -sf "${kitty_dark_theme}" "${kitty_theme_symlink}"
    export GLAMOUR_STYLE=dark
  else
    export KITTY_COLORS="light"
    ln -sf "${kitty_light_theme}" "${kitty_theme_symlink}"
    export GLAMOUR_STYLE=light
  fi

  # Kitty listens on a UNIX socket, so that we can send commands even while in
  # tmux (which swallows the kitty escape codes)
  for socket in /tmp/kitty*; do
    kitty @ --to "unix:${socket}" set-colors -a -c "${kitty_theme_symlink}"
  done

  set_bat_theme
  set_fzf_default_opts
}

case $OSTYPE in
  linux*)
    local envfile="${HOME}/.zsh.d/env.Linux.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
  darwin*)
    local envfile="${HOME}/.zsh.d/env.Darwin.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
esac

export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Reduce delay for key combinations in order to change to vi mode faster
# See: http://www.johnhawthorn.com/2012/09/vi-escape-delays/
# Set it to 10ms
export KEYTIMEOUT=1

# homebrew
export PATH=/opt/homebrew/bin:$PATH

# asdf
if [ -e /usr/local/opt/asdf/asdf.sh ]; then
  source /usr/local/opt/asdf/asdf.sh
fi

# node.js
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

# golang
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export GOPRIVATE="github.com/emremicroservices/*"

# direnv
if type direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# fzf
# fzf via Homebrew
if [ -e /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
else
  # fzf via local installation
  if [ -e ~/.fzf ]; then
    source ~/.fzf/shell/key-bindings.zsh
    source ~/.fzf/shell/completion.zsh
    if [[ ! "$PATH" == *$HOME.fzf/bin* ]]; then
      export PATH="$PATH:$HOME/.fzf/bin"
    fi
  fi
fi

if type fzf &> /dev/null && type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  set_fzf_default_opts
fi

# Try out `z`
if [ -e /opt/homebrew/etc/profile.d/z.sh ]; then
  source /opt/homebrew/etc/profile.d/z.sh
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if type bat &> /dev/null; then
  alias cat=bat
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

if [ "$TMUX" = "" ]; then tmux -u attach -t main || tmux -u new -s main; fi

export LDFLAGS="/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="/opt/homebrew/opt/libpq/include"

CARGO_NET_GIT_FETCH_WITH_CLI=true

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "${HOME}/.ssh:/root/.ssh" -v "/run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock" -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/basecamp/kamal:latest'
