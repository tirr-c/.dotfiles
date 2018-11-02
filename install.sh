#!/bin/sh

set -e

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
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# junegunn/vim-plug
echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# junegunn/fzf
echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Symlinking
BASEDIR="$(dirname "$0")"
DOTFILES=".zshrc .vimrc.common .vimrc .ideavimrc .tmux.conf .npmrc"
for dotfile in $DOTFILES; do
  echo "Symlinking $dotfile"
  ln -rsf "$BASEDIR/$dotfile" "~/$dotfile"
done

echo 'Symlinking Neovim init.vim'
mkdir -p ~/.config/nvim
ln -rsf "$BASEDIR/.vimrc" ~/.config/nvim/init.vim
