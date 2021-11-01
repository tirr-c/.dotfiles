#!/bin/bash
set -euo pipefail

if [[ ! -d ~/.zinit/bin/.git ]]; then
  echo 'zinit not found in ~/.zinit/bin' >&2
  exit 1
fi

cd ~/.zinit/bin
git remote set-url origin 'https://github.com/zdharma-continuum/zinit.git'
git fetch origin
