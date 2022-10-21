#!/usr/bin/env zsh
emulate -LR zsh
setopt extendedglob typesetsilent

typeset -a terms=('tmux-256color' 'alacritty-direct')

typeset -a targets=()
for target in $terms; do
  if infocmp $target >/dev/null 2>&1; then
    echo "Terminfo $target is already installed" 2>&1
  else
    targets+=($target)
  fi
done

echo "Installing terminfo ${(j:, :)targets}" 2>&1
local tempfile="$(mktemp)"
curl -sSfL https://invisible-island.net/datafiles/current/terminfo.src.gz | gunzip >$tempfile
/usr/bin/tic -xe ${(j:,:)targets} $tempfile
rm $tempfile
