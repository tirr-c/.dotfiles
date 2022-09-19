# If not running interactively, don't do anything
[[ -o interactive ]] || return

# Disable undef
stty stop undef

# GPG
export GPG_TTY=$TTY

# term
export TERM="xterm-256color"

# Homebrew
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

#
# zinit
#
if [[ -d "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" ]]; then
  ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
elif [[ -d ~/.zinit ]]; then
  ZINIT_HOME=~/.zinit/bin
fi

if [[ -v ZINIT_HOME ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  # sbin ice
  zinit for \
    light-mode zdharma-continuum/zinit-annex-bin-gem-node

  # fzf
  zinit wait'' lucid for \
    from'gh-r' sbin'fzf' junegunn/fzf \
    https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh

  # kubectx, kubens
  zinit wait'' lucid for \
    from'gh-r' bpick'kubectx;kubens' sbin'kubectx;kubens' ahmetb/kubectx

  # pyenv
  zinit wait'' lucid for \
    as'null' \
    atload'! export PYENV_ROOT=$ZPFX/pyenv; export PATH=$PWD/bin:$PATH; eval "$(pyenv init -)"' \
    pyenv/pyenv \
    as'null' \
    atclone'mkdir -p $ZPFX/pyenv/plugins; ln -s $PWD $ZPFX/pyenv/plugins/pyenv-virtualenv' \
    atload'! eval "$(pyenv virtualenv-init -)"' \
    pyenv/pyenv-virtualenv

  # nodenv
  zinit wait'' lucid for \
    as'null' \
    atload'! export NODENV_ROOT=$ZPFX/nodenv; export PATH=$PWD/bin:$PATH; eval "$(nodenv init -)"' \
    @nodenv/nodenv \
    as'null' \
    atclone'mkdir -p $ZPFX/nodenv/plugins; ln -s $PWD $ZPFX/nodenv/plugins/node-build' \
    @nodenv/node-build

  # completions
  zinit wait'' lucid for \
    light-mode simnalamburt/cgitc \
    as'program' pick'git-select-branch' autoload'git-select-branch' \
      tirr-c/git-select-branch \
    light-mode blockf zsh-users/zsh-completions \
    light-mode atinit'zicompinit; zicdreplay' zdharma-continuum/fast-syntax-highlighting

  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  # powerlevel10k
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  zinit for \
    atload'! [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' \
    romkatv/powerlevel10k
else
  PS1='%n@%m:%~%# '
  autoload -Uz compinit
  compinit
fi

if [[ -v ZINIT_HOME ]]; then
  # fzf
  [[ -n "$HISTFILE" ]] || HISTFILE="$HOME/.zsh_history"
  HISTSIZE=10000
  SAVEHIST=10000

  export FZF_COMPLETION_TRIGGER='\'

  # Use fd if available
  if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND='fd --type f'

    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".yarn" --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
      fd --type d --hidden --exclude ".yarn" --follow --exclude ".git" . "$1"
    }
  fi
fi

#
# Terminal title
#
function precmd() {
  print -Pn "\e]0;[%n@%m %~]%#\a"
}

function preexec() {
  print -Pn "\e]0;[%n@%m %~]%# "
  echo -n $2
  echo -ne "\a"
}

#
# zsh-sensible
#
alias mv='mv -i'
alias cp='cp -i'
alias less='less -SR'

setopt auto_cd hist_ignore_all_dups share_history
zstyle ':completion:*' menu select

#
# lscolors
#
export LSCOLORS="Gxfxcxdxbxegedxbagxcad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=30;46:tw=0;42:ow=30;43"
export TIME_STYLE='long-iso'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
autoload -U colors && colors

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

# ~/.local/bin
[[ ! -d ~/.local/bin ]] || export PATH="$HOME/.local/bin:$PATH"
# ~/.local/lib
[[ ! -d ~/.local/lib ]] || export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"

# Ruby
if hash ruby 2>/dev/null && hash gem 2>/dev/null; then
  export GEM_HOME=$(ruby -e 'print Gem.user_dir')
  export PATH="$PATH:$GEM_HOME/bin"
fi

# Golang
if hash go 2>/dev/null; then
  export GOPATH=~/.go
  mkdir -p $GOPATH
  export PATH="$GOPATH/bin:$PATH"
fi

# cargo install
if [[ -d ~/.cargo/bin ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# yarn
if [[ -d ~/.yarn ]]; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

# yarn global
if hash yarn 2>/dev/null; then
  export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi

# deno
if [[ -d ~/.deno ]]; then
  export DENO_INSTALL="$HOME/.deno/"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# opam
if [[ -r ~/.opam/opam-init/init.zsh ]]; then
  . ~/.opam/opam-init/init.zsh >/dev/null 2>&1
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
if [[ -d ~/x-tools ]]; then
  TPATH="$PATH"
  for dir in $(find "$HOME/x-tools" -mindepth 1 -maxdepth 1 -type d -a ! -name '*HOST-*' -printf '%f '); do
    TPATH="$TPATH:$HOME/x-tools/$dir/bin"
  done
  export PATH="$TPATH"
fi

# exa
if hash exa 2>/dev/null; then
  alias exa='exa --group-directories-first --color=always'
  alias ls='exa'
  alias l='exa -lgab --time-style iso'
else
  alias ls='ls --color=always'
  alias l='ls -lahk'
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
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
