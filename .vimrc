source $HOME/.vimrc.common

set shell=/bin/bash

set pastetoggle=<F8>

set textwidth=80
set formatoptions-=t

set cindent ai si et
set ts=2 sts=2 sw=2 bs=2
autocmd FileType typescript set ts=4 sts=4 sw=4 tw=120

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

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

Plug 'Shougo/vimproc.vim', {'do' : 'make'} " for tsuquyomi

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'jason0x43/vim-js-indent'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'Quramy/tsuquyomi'
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
if executable('fd')
  function! FindPackageRoot(startdir)
    let current = fnamemodify(a:startdir, ':p')
    while empty(glob(current.'/package.json'))
      if current ==# '/'
        return ''
      endif
      let current = fnamemodify(current, ':h')
    endwhile
    return current
  endfunction

  function! RunDtsFzf(base, bang)
    let package_root = FindPackageRoot(a:base)
    let node_modules_dir = glob(package_root . '/node_modules')
    if node_modules_dir ==# ''
      echoerr 'node_modules not found in ' . package_root
      return
    endif
    let fzf_dict = fzf#wrap(
      \ 'd-ts',
      \ {
      \   'source': "fd --no-ignore -c'always' -e'.d.ts' -tf",
      \   'dir': node_modules_dir,
      \   'options': ['--ansi', '--prompt=node_modules/']
      \ },
      \ a:bang)
    call fzf#run(fzf_dict)
  endfunction
  command! -bang Dts
    \ call RunDtsFzf(getcwd(), <bang>0)
  command! -bang BufferDts
    \ call RunDtsFzf(expand('%:p:h'), <bang>0)
  nmap <leader>d :Dts<cr>
  nmap <leader><leader>d :Dts!<cr>
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
let g:xml_syntax_folding = 0

" typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" dark red
hi tsxTagName ctermfg=168 guifg=#E06C75

" orange
hi tsxCloseString ctermfg=210 guifg=#F99575
hi tsxCloseTag ctermfg=210 guifg=#F99575
hi tsxAttributeBraces ctermfg=210 guifg=#F99575
hi tsxEqual ctermfg=210 guifg=#F99575

" yellow
hi tsxAttrib ctermfg=216 guifg=#F8BD7F cterm=italic
