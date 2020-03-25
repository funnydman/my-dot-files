set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'tpope/vim-fugitive'
Plugin 'dracula/vim', {'name': 'dracula'}
Plugin 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8
set clipboard=unnamedplus " for easy copy pasting

" searching
set incsearch

" adds fancy colors, for eyes
syntax on
" colorscheme dracula


set nu
set ruler
set autoread " watch for file changres
set showcmd    " Show (partial) command in status line.
set noerrorbells " No annoying sound

" formatting
set tabstop=4
set shiftwidth=4
set expandtab
retab
set autoindent
set smartindent
set cindent
set colorcolumn=110
highlight ColorColumn ctermbg=darkgray


" filetype
au FileType asm setlocal ft=nasm
" enable all Python syntax highlighting features


" Disable arrows usage
noremap <silent> <Up> <Nop>
noremap <silent> <Down> <Nop>
noremap <silent> <Left> <Nop>
noremap <silent> <Right> <Nop>

" Disable arrow keys in Insert mode
ino <Up> <Nop>
ino <Down> <Nop>
ino <Left> <Nop>
ino <Right> <Nop>

