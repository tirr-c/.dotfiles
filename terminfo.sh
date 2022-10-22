#!/usr/bin/env zsh
emulate -LR zsh
setopt extendedglob typesetsilent

typeset -a terms=('xterm-256color' 'tmux-256color' 'alacritty')

typeset -a targets=()
for target in $terms; do
  if infocmp $target >/dev/null 2>&1; then
    echo "Terminfo $target is already installed" >&2
  else
    targets+=($target)
  fi
done

if (( ! ${#targets} )); then
  echo 'Nothing to install' >&2
  exit 0
fi

echo "Installing terminfo ${(j:, :)targets}" >&2
curl -sSfL https://invisible-island.net/datafiles/current/terminfo.src.gz | \
  gunzip | \
  /usr/bin/tic -xe ${(j:,:)targets} /dev/stdin
