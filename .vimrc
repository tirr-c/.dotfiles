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

" coc.nvim
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
set hidden
set updatetime=300
set shortmess+=c
inoremap <silent><expr> <C-space> coc#refresh()
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)

nmap <leader>ff <Plug>(coc-fix-current)

nmap <leader><leader>f <Plug>(coc-format)
augroup mygroup
  autocmd!
  autocmd FileType javascript,typescript,typescript.tsx,rust,json
        \ setl formatexpr=CocAction('formatSelected')
augroup end

nmap <leader>a <Plug>(coc-codeaction-selected)
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader><leader>a <Plug>(coc-codeaction)

nmap <leader>rn <Plug>(coc-rename)

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'jason0x43/vim-js-indent'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'posva/vim-vue'
Plug 'hashivim/vim-terraform'
Plug 'digitaltoad/vim-pug'

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

" popup menu
hi Pmenu ctermbg=236 ctermfg=252 guibg=#3f3f3f guifg=#d9d9d9
