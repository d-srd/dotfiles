# dotfiles
various settings for CLI applications

## Quickstart
* `brew install neovim zsh zsh-syntax-highlighting`
* follow `zsh-syntax-highlighting` install instructions
* `ln -s dotfiles/.zshrc .zshrc` && `ln -s dotfiles/.zshenv .zshenv`
* in your `.config/nvim/init.vim` put `source dotfiles/.nvim`

## .nvimrc
Minimal NeoVim distribution, containing:
* [vim-airline](https://github.com/vim-airline/vim-airline) - a cool statusline
* [gruvbox](https://github.com/morhetz/gruvbox) - an awesome color scheme
* [rust-vim](https://github.com/rust-lang/rust.vim) - Rust support for Vim
* [vim-polyglot](https://github.com/sheerun/vim-polyglot) - A collection of language packs for Vim

## .zshrc

