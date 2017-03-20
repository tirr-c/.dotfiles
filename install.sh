#!/bin/sh

# Working directory check
if [ "$(pwd)" != "$HOME" ]; then
  echo "Run the script at your home directory."
  exit 1
fi

# Dependencies
DEPS="zsh curl git"
for dep in $DEPS; do
  echo "Checking dependency: $dep"
  which $dep >/dev/null 2>&1
  if [ ! $? ]; then
    echo "Please install $dep."
    exit 1
  fi
done

# zplug/zplug
echo "Installing zplug"
curl -sL zplug.sh/installer | zsh

# junegunn/vim-plug
echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# junegunn/fzf
echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Symlinking
BASEDIR="$(dirname "$0")"
DOTFILES=".zshrc .vimrc .tmux.conf"
for dotfile in $DOTFILES; do
  echo "Symlinking $dotfile"
  ln -sf "$BASEDIR/$dotfile"
done
