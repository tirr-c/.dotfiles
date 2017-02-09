set encoding=utf-8
set fileencoding=utf-8
set shell=/bin/bash
set nocompatible
set nobackup noswapfile
set autoread
set number
set nowrap
set startofline
set scrolloff=3
set splitbelow

set cindent ai si et
set ts=2 sts=2 sw=2 bs=2

set hlsearch incsearch showmatch
set ignorecase smartcase nowrapscan

set pastetoggle=<F8>

nnoremap ; :
nnoremap <silent> <C-_> :split<CR>
nnoremap <silent> <C-\> :vertical split<CR>
nnoremap <silent> <C-h> :vertical resize -5<CR>
nnoremap <silent> <C-j> :resize -3<CR>
nnoremap <silent> <C-k> :resize +3<CR>
nnoremap <silent> <C-l> :vertical resize +5<CR>

" Persistent history
" from simnalamburt/.dotfiles
if has('persistent_undo')
  let vimdir='$HOME/.vim'
  let &runtimepath.=','.vimdir
  let vimundodir=expand(vimdir.'/undodir')
  call system('mkdir -p '.vimundodir)

  let &undodir=vimundodir
  set undofile
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-sensible'

Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/seoul256.vim'

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'

call plug#end()

let g:airline_powerline_fonts = 1

let g:strip_whitespace_on_save = 1

let g:seoul256_background = 233
colo seoul256
