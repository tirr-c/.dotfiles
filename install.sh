#!/bin/sh
set -euo pipefail

# Locale check
locale -k LC_CTYPE | grep -qi 'charmap="utf-\+8"' || (echo 'Locale should be UTF-8'; exit 1)

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

# zdharma/zinit
echo "Installing zinit"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

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
DOTFILES=".zshrc .p10k.zsh .vimrc .ideavimrc .tmux.conf .npmrc .gitconfig .gitignore-global"
for dotfile in $DOTFILES; do
  echo "Symlinking $dotfile"
  ln -rsf "$BASEDIR/$dotfile" "$HOME/$dotfile"
done

echo 'Symlinking Neovim init.vim'
mkdir -p ~/.config/nvim
ln -rsf "$BASEDIR/.vimrc" ~/.config/nvim/init.vim

echo 'Symlinking coc-settings.json'
mkdir -p ~/.config/nvim
ln -rsf "$BASEDIR/coc-settings.json" ~/.config/nvim/coc-settings.json
