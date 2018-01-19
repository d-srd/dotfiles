" put this in ~/.config/nvim/ 
" or anywhere and source it in your init.vim
" https://github.com/neovim/neovim/issues/3499#issuecomment-169085397

if &compatible
  set nocompatible               " Be iMproved
endif

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'morhetz/gruvbox'
  Plug 'rust-lang/rust.vim'
  Plug 'sheerun/vim-polyglot'
call plug#end()

" make it pretty
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme gruvbox

" make it shiny
set showmatch
set number
set expandtab
set tabstop=4
set shiftwidth=4
set ignorecase
set smartcase
set gdefault
set magic

" make it funny
set laststatus=2
let g:airline_theme= 'gruvbox'
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''
let g:airline#extensions#tabline#enabled = 1

" make it runny (?)
nnoremap - :
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" taken from: https://vi.stackexchange.com/a/2187
nnoremap <C-E> :set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>
