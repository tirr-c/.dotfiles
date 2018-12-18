# Adopted from simnalamburt/.dotfiles

# If not running interactively, don't do anything
[[ -o interactive ]] || return

# WSL: Why do I need this?
umask 022

# GPG
export GPG_TTY=`tty`

# Chrome to Chromium
export CHROME_BIN="$(which chromium)"

#
# zplug
#
autoload -U is-at-least
if is-at-least 4.3.9 && [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'
  zplug 'zsh-users/zsh-completions'
  zplug 'zsh-users/zsh-syntax-highlighting'
  zplug 'simnalamburt/cgitc'
  zplug 'simnalamburt/shellder', as:theme
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  zplug load
else
  PS1='%n@%m:%~%# '
fi

#
# Terminal title
#

precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

#
# zsh-sensible
#
stty stop undef

alias l='ls -lah'
alias mv='mv -i'
alias cp='cp -i'

setopt auto_cd
zstyle ':completion:*' menu select


#
# lscolors
#
autoload -U colors && colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Find the option for using colors in ls, depending on the version: Linux or BSD
if [[ "$(uname -s)" == "NetBSD" ]]; then
  # On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
  # otherwise, leave ls as is, because NetBSD's ls doesn't support -G
  gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=tty'
elif [[ "$(uname -s)" == "OpenBSD" ]]; then
  # On OpenBSD, "gls" (ls from GNU coreutils) and "colorls" (ls from base,
  # with color and multibyte support) are available from ports.  "colorls"
  # will be installed on purpose and can't be pulled in by installing
  # coreutils, so prefer it to "gls".
  gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=tty'
  colorls -G -d . &>/dev/null 2>&1 && alias ls='colorls -G'
else
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi


#
# zsh-substring-completion
#
setopt complete_in_word
setopt always_to_end
WORDCHARS=''
zmodload -i zsh/complist

# Substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


setopt hist_save_no_dups

#
# zshrc
#

# typo alias
alias sl=ls
alias ㅣ=l
alias 니=ls

# fzf
if [ -f ~/.fzf.zsh ]; then
  [ -z "$HISTFILE" ] && HISTFILE=$HOME/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  source ~/.fzf.zsh

  export FZF_COMPLETION_TRIGGER='\'

  # Use fd if available
  if hash fd 2>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f'

    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude ".git" . "$1"
    }
  fi

  if hash git 2>/dev/null; then
    gbfzf() {
      git branch | egrep -v '^\*' | \
        fzf --ansi \
        --prompt='git branch> ' \
        --preview="git log --color=always --decorate --oneline --graph {1} | head -n $LINES"
    }

    alias gcoz='git checkout $(gbfzf)'
  fi
fi

# tmux
if [ "$TMUX" = "" ]; then; export TERM="xterm-256color"; fi

# ~/.local/bin
if [ -d ~/.local/bin ]; then; export PATH="$HOME/.local/bin:$PATH"; fi
# ~/.local/lib
if [ -d ~/.local/lib ]; then; export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"; fi

export DEFAULT_USER="$USER" # TODO: https://github.com/simnalamburt/shellder/issues/10

# Ruby
if hash ruby 2>/dev/null && hash gem 2>/dev/null; then
  export GEM_HOME=$(ruby -e 'print Gem.user_dir')
  export PATH="$PATH:$GEM_HOME/bin"
fi

# Golang
if hash go 2>/dev/null; then
  export GOPATH=~/.go
  mkdir -p $GOPATH
  export PATH="$PATH:$GOPATH/bin"
fi

# cargo install
if [ -d ~/.cargo/bin ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

# racer
RUST_CHANNEL=stable
RUST_TARGET=x86_64-unknown-linux-gnu
if hash racer 2>/dev/null && [ -d ~/ ]; then
  export RUST_SRC_PATH="$HOME/.multirust/toolchains/${RUST_CHANNEL}-${RUST_TARGET}/lib/rustlib/src/rust/src"
fi

# yarn
if [ -d ~/.yarn ]; then
  export PATH="$PATH:$HOME/.yarn/bin"
fi

# yarn global
if hash yarn 2>/dev/null; then
  export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
fi

# torch
if [ -d ~/torch/install ]; then
  export PATH="$HOME/torch/install/bin:$PATH"
  export LD_LIBRARY_PATH="$HOME/torch/install/lib:$LD_LIBRARY_PATH"
fi

# pyenv
if [ -d ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  if [ -d ${PYENV_ROOT}/plugins/pyenv-virtualenv ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# nodenv
if [ -d ~/.nodenv ]; then
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"
fi

# ag to rg
if hash rg 2>/dev/null; then
  if ! hash ag 2>/dev/null; then
    alias ag=rg
  fi
fi

# open
if hash gio 2>/dev/null; then
  function open() {
    gio open $1 >/dev/null 2>&1
  }
elif hash xdg-open 2>/dev/null; then
  function open() {
    xdg-open $1 >/dev/null 2>&1
  }
fi

# pacman, bauerbill
if hash bauerbill 2>/dev/null; then
  alias bb='sudo bauerbill'
  alias pkgupdate='sudo bauerbill -Syu'
elif hash pacman 2>/dev/null; then
  alias pkgupdate='sudo pacman -Syu'
fi

# x-tools
if [ -d ~/x-tools ]; then
  TPATH="$PATH"
  for dir in $(find "$HOME/x-tools" -mindepth 1 -maxdepth 1 -type d -a ! -name '*HOST-*' -printf '%f '); do
    TPATH="$TPATH:$HOME/x-tools/$dir/bin"
  done
  export PATH="$TPATH"
fi

# exa
if hash exa 2>/dev/null; then
  alias ls='exa --group-directories-first'
  alias l='exa -la --group-directories-first --time-style iso'
fi

# wttr.in
wttr() {
  LOCATION=${1// /+}
  curl ko.wttr.in/$LOCATION
}

# neovim, vim
if hash nvim 2>/dev/null; then
  export EDITOR=nvim
  alias vim='nvim'
  alias vi='nvim'
elif hash vim 2>/dev/null; then
  export EDITOR=vim
  alias vi='vim'
fi
