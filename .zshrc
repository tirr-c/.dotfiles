# If not running interactively, don't do anything
[[ -o interactive ]] || return

# Early zsh setup [[[1
# Disable undef
stty stop undef

# GPG
export GPG_TTY=$TTY

# term
export TERM="xterm-256color"

# Homebrew [[[2
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

# zinit [[[1

# Path configuration [[[2
if [[ -d "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" ]]; then
  ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
elif [[ -d ~/.zinit ]]; then
  ZINIT_HOME=~/.zinit/bin
fi
# ]]]2

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

  # personal env configuration
  zinit wait'' lucid for \
    tirr-c/zsh-env-setup

  # completions
  zinit wait'' lucid for \
    light-mode simnalamburt/cgitc \
    as'program' pick'git-select-branch' autoload'git-select-branch' \
      tirr-c/git-select-branch \
    light-mode blockf zsh-users/zsh-completions \
    light-mode atinit'zicompinit; zicdreplay' zdharma-continuum/fast-syntax-highlighting

  # powerlevel10k [[[2
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  zinit for \
    atload'! [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' \
    romkatv/powerlevel10k
  # ]]]2
else
  PS1='%n@%m:%~%# '
  autoload -Uz compinit
  compinit
fi

# zshrc [[[1

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

# wttr.in
wttr() {
  LOCATION=${1// /+}
  curl v2.wttr.in/$LOCATION
}

# ]]]1

# Load local zshrc
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# vim:ft=zsh:tw=100:sw=2:sts=2:et:foldmethod=marker:foldmarker=[[[,]]]
