UNAME := $(shell uname)
DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.gitignore $(HOME)/.gitignore_global
zsh: $(HOME)/.zshrc
tmux: $(HOME)/.tmux.conf

ghostty:
  mkdir -p $(HOME)/.config/ghostty
  ln -sf $(DOTFILE_PATH)/ghostty.conf $(HOME)/.config/ghostty/config

all: git zsh tmux ghostty
