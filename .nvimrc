" put this in ~/.config/nvim/ 
" or anywhere and source it in your init.vim
" https://github.com/neovim/neovim/issues/3499#issuecomment-169085397

if &compatible
  set nocompatible               " Be iMproved
endif

" plugins
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'vim-airline/vim-airline'                    " statusline, but prettier and more functional
  Plug 'morhetz/gruvbox'                            " colorscheme
  Plug 'rust-lang/rust.vim'                         " rewrite vim in rust when???
  Plug 'sheerun/vim-polyglot'                       " syntax support for basically everything, including hieroglyphs
  Plug 'jpalardy/vim-slime'                         " send text to repl in screen/tmux/:terminal/etc.
call plug#end()

" make it pretty
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme gruvbox

" make it shiny
set showmatch       " match parentheses
set number          " line numbers
set expandtab       " tabs to spaces
set tabstop=4       " one tab = 4 spaces
set shiftwidth=4    " ^
set ignorecase      " ignore case in search
set smartcase
set gdefault
set magic           " magic

" airline config
set laststatus=2
let g:airline_theme = 'gruvbox'
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''
let g:airline#extensions#tabline#enabled = 1

" slime config
let g:slime_target = "neovim"

" keybindings
nnoremap - :

" use <C-hjkl> to switch workspaces
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" taken from: https://vi.stackexchange.com/a/2187
nnoremap <C-E> :set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>

nnoremap <C-N> :set nohlsearch

" <Esc> exits terminal mode
tnoremap <Esc> <C-\><C-n>
