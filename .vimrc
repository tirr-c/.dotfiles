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
set splitbelow splitright

set cindent ai si et
set ts=2 sts=2 sw=2 bs=2

set hlsearch incsearch showmatch
set ignorecase smartcase nowrapscan

set pastetoggle=<F8>

set textwidth=80
set formatoptions-=t

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

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
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-sensible'

Plug 'ntpeters/vim-better-whitespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/seoul256.vim'

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'posva/vim-vue'

call plug#end()

let g:fzf_layout = { 'right': '~40%' }
nmap <leader><tab> :Files<CR>
nmap <leader><leader><tab> :Files!<CR>
nmap <leader>q :Buffers<CR>
nmap <leader><leader>q :Buffers!<CR>
if executable('rg')
  " From junegunn/fzf.vim#readme
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)
  nmap <leader>r :Rg<space>
  nmap <leader><leader>r :Rg!<space>
endif

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:strip_whitespace_on_save = 1

let g:seoul256_background = 233
colo seoul256
if v:version >= 703
  set colorcolumn=+1,+2,+3
  hi ColorColumn ctermbg=239
endif

let g:jsx_ext_required = 0
