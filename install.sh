#!/usr/bin/env zsh
emulate -LR zsh
setopt extendedglob typesetsilent

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
typeset basedir="${0:h}"

# Locale check
typeset -a locale_lines=( "${(f@)$(locale -k LC_CTYPE)}" )
if [[ -z ${locale_lines[(r)(#i)*utf-8*]} ]]; then
  echo 'Locale should be UTF-8'
  exit 1
fi

# Dependencies
typeset -a deps=(curl git)
for dep in $deps; do
  echo "Checking dependency: $dep"
  if (( ! ${+commands[$dep]} )); then
    echo "Please install $dep."
    exit 1
  fi
done

# zdharma/zinit
echo "Installing zinit"
sh -c "$(curl -fsSL https://git.io/zinit-install)"

# junegunn/vim-plug
echo "Installing vim-plug"
mkdir -p ~/.vim/autoload
mkdir -p ~/.local/share/nvim/site/autoload
curl -sSfL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | \
  tee ~/.vim/autoload/plug.vim >~/.local/share/nvim/site/autoload/plug.vim

# Symlinking
typeset -a dotfiles=(.zshrc .p10k.zsh .vimrc .ideavimrc .tmux.conf .gitconfig .gitexclude)
for dotfile in $dotfiles; do
  echo "Symlinking $dotfile"
  ln -rsf "$basedir/$dotfile" "$HOME/$dotfile"
done

echo 'Symlinking htoprc'
mkdir -p ~/.config/htop
ln -rsf "$basedir/htoprc" ~/.config/htop/htoprc

echo 'Symlinking Neovim init.vim'
mkdir -p ~/.config/nvim
ln -rsf "$basedir/.vimrc" ~/.config/nvim/init.vim

echo 'Symlinking coc-settings.json'
mkdir -p ~/.config/nvim
ln -rsf "$basedir/coc-settings.json" ~/.config/nvim/coc-settings.json

# Install terminfo
"$basedir/terminfo.sh"
