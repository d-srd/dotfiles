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
let mapleader="\<SPACE>"
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

" because why not
nnoremap - :
