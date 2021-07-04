export ZSH=/Users/$USER/.oh-my-zsh

ZSH_THEME=robbyrussell

ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  fzf
  zsh-autosuggestions
  colored-man-pages
)
source "$ZSH/oh-my-zsh.sh"

export UPDATE_ZSH_DAYS=7
export DISABLE_UPDATE_PROMPT=true # accept updates by default

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR=vim
else
  export EDITOR=nvim
fi

# Homebrew install path customization
export HOMEBREW="$HOME/.homebrew"
if [ ! -d "$HOMEBREW" ]; then
  # fallback
  export HOMEBREW=/usr/local
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

PATH=/opt/homebrew/bin:$PATH
PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"
PATH="$HOME/.composer/vendor/bin:$PATH"

# Add zsh completion scripts installed via Homebrew
fpath=("$HOMEBREW/share/zsh-completions" $fpath)
fpath=("$HOMEBREW/share/zsh/site-functions" $fpath)

# Dotfiles
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

# load zsh plugins installed via brew
if [[ -d "$HOMEBREW/share/zsh-syntax-highlighting" ]]; then
	source "$HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [[ -d "$HOMEBREW/share/zsh-autosuggestions" ]]; then
	source "$HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

PATH="${HOME}/go/bin:${PATH}"

# direnv hook
if command -v direnv > /dev/null; then
	eval "$(direnv hook zsh)"
fi

# nvm
# export NVM_LAZY_LOAD=true
# export NVM_COMPLETION=true
# export NVM_DIR="$HOME/.nvm"
#  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# finally, export the PATH
export PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Prompt

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
# local promptnormal="%{$fg_bold[black]%}λ %{$reset_color%}"
local promptnormal="φ %{$reset_color%}"
local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

PROMPT='${dir_info}$(git_prompt_info) %(1j.$promptjobs.$promptnormal)'

# Taken from here: https://zenbro.github.io/2015/07/23/show-exit-code-of-last-command-in-zsh
function check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%{$fg[red]%}-%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg[red]%}-%{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  fi
}

RPROMPT='$(check_last_exit_code)'

export LSCOLORS="Gxfxcxdxbxegedabagacad"

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

  set_fzf_default_opts
}

if type nvim &> /dev/null; then
  alias vim='nvim'
  export EDITOR='nvim'
  export PSQL_EDITOR='nvim -c"set filetype=sql"'
  export GIT_EDITOR='nvim'
else
  export EDITOR='vim'
  export PSQL_EDITOR='vim -c"set filetype=sql"'
  export GIT_EDITOR='vim'
fi

if type fzf &> /dev/null && type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  set_fzf_default_opts
fi

if type bat &> /dev/null; then
  export BAT_THEME=ansi
fi

if type exa &> /dev/null; then
  alias ls=exa
fi

if [ "$TMUX" = "" ]; then tmux -u attach -t main || tmux -u new -s main; fi
