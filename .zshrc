# Adopted from simnalamburt/.dotfiles

# If not running interactively, don't do anything
[[ -o interactive ]] || return

# Disable undef
stty stop undef

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# WSL: Why do I need this?
umask 022

# GPG
export GPG_TTY=`tty`

# Chrome to Chromium
export CHROME_BIN="$(which chromium)"

#
# zinit
#
autoload -U is-at-least
if is-at-least 5.1 && [ -d ~/.zinit ]; then
  source ~/.zinit/bin/zinit.zsh
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  zinit ice depth=1
  zinit light romkatv/powerlevel10k

  zinit light zsh-users/zsh-completions
  zinit light zdharma/fast-syntax-highlighting
  zinit light simnalamburt/cgitc

  autoload -Uz compinit
  compinit
  zinit cdreplay
else
  PS1='%n@%m:%~%# '
  autoload -Uz compinit
  compinit
fi

#
# powerlevel10k
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# Terminal title
#
precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

#
# zsh-sensible
#
alias l='ls -lah'
alias mv='mv -i'
alias cp='cp -i'
alias less='less -SR'

setopt auto_cd histignorealldups sharehistory
zstyle ':completion:*' menu select

#
# lscolors
#
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedxbagxcad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=30;46:tw=0;42:ow=30;43"
export TIME_STYLE='long-iso'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#
# zsh-substring-completion
#
setopt complete_in_word
setopt always_to_end
WORDCHARS=''
zmodload -i zsh/complist

# Substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#
# zshrc
#

# typo alias
alias sl=ls
alias ㅣ=l
alias 니=ls
alias ㅣㄴ=ls
alias ㄴㅣ=ls

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
      fd --hidden --follow --exclude ".yarn" --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --hidden --exclude ".yarn" --follow --exclude ".git" . "$1"
    }
  fi

  if hash git 2>/dev/null; then
    gbfzf() {
      git branch | egrep -v '^\*' | sed -e 's/^ *//' | \
        fzf --ansi \
        --prompt='git branch> ' \
        --preview="git log --color=always --decorate --oneline --graph {1} | head -n $LINES"
    }

    gcoz() {
      local branch="$(gbfzf)"
      git checkout "$branch"
    }
  fi
fi

# tmux
if [ "$TMUX" = "" ]; then; export TERM="xterm-256color"; fi

# ~/.local/bin
if [ -d ~/.local/bin ]; then; export PATH="$HOME/.local/bin:$PATH"; fi
# ~/.local/lib
if [ -d ~/.local/lib ]; then; export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"; fi

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
fi
if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
  if hash pyenv-virtualenv-init 2>/dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# nodenv
if [ -d ~/.nodenv ]; then
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"
fi

# opam
if [ -r /home/tirr/.opam/opam-init/init.zsh ]; then
  . /home/tirr/.opam/opam-init/init.zsh > /dev/null 2> /dev/null
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
  alias ls='exa --group-directories-first --color=always'
  alias l='exa -la --group-directories-first --time-style iso --color=always'
fi

# wttr.in
wttr() {
  LOCATION=${1// /+}
  curl v2.wttr.in/$LOCATION
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

# Load local zshrc
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
