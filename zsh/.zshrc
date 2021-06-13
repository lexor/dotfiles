export ZSH=/Users/$USER/.oh-my-zsh

ZSH_THEME=geoffgarside
# ZSH_THEME=lambda

plugins=(git colored-man-pages fzf)
source "$ZSH/oh-my-zsh.sh"

PROMPT='%{$fg[green]%}%c%{$reset_color%}$(git_prompt_info) %{$fg[yellow]%}%(!.#.$)%{$reset_color%} '

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

PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"
PATH="$HOME/.composer/vendor/bin:$PATH"

# Add zsh completion scripts installed via Homebrew
fpath=("$HOMEBREW/share/zsh-completions" $fpath)
fpath=("$HOMEBREW/share/zsh/site-functions" $fpath)

# Load custom functions
if [[ -f "$HOME/workspace/dotfiles/zsh/functions.zsh" ]]; then
	source "$HOME/workspace/dotfiles/zsh/functions.zsh"
else
	echo >&2 "WARNING: can't load shell functions"
fi

# Load custom aliases
if [[ -f "$HOME/workspace/dotfiles/zsh/aliases.zsh" ]]; then
	source "$HOME/workspace/dotfiles/zsh/aliases.zsh"
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

# Dotfiles
export DOTFILES="$HOME/workspace/dotfiles"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LSCOLORS="Gxfxcxdxbxegedabagacad"

if [ "$TMUX" = "" ]; then tmux attach -t emredeger || tmux new -s emredeger; fi
