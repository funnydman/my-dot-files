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
Plugin 'ryanoasis/vim-devicons'
Plugin 'dracula/vim', {'name': 'dracula'}
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary' " for easy commenting -gc
Plugin 'mboughaba/i3config.vim' " syntax highlighting for i3 config file
Plugin 'vim-airline/vim-airline' " for pretty bar
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jreybert/vimagit' " git operations in few key press
Plugin 'scrooloose/nerdtree'
Plugin 'vimwiki/vimwiki'
Plugin 'mbbill/undotree'
Plugin 'universal-ctags/ctags'
Plugin 'morhetz/gruvbox'
Plugin 'arakashic/chromatica.nvim'
Plugin 'junegunn/fzf.vim'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"  defaults
set encoding=utf-8
set clipboard=unnamedplus " for easy copy pasting
set number relativenumber
" searching
set incsearch
set path+=**
command! MakeTags !ctags -R .

:map <F11>  :sp tags<CR>:%s/^\([^   :]*:\)\=\([^    ]*\).*/syntax keyword Tag \2/<CR>:wq! tags.vim<CR>/^<CR><F12>
:map <F12>  :so tags.vim<CR>

" adds fancy colors, for eyes
syntax on
" colorscheme dracula

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright
" Nerd tree
map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Move to beginning/end of line
nnoremap B ^
nnoremap E $

" Shift to the next round tab stop.
set shiftround
" Set auto indent spacing.
set shiftwidth=2

" Replace ex mode with gq
map Q gq

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

set nu
set ruler
set autoread " watch for file changres
set showcmd    " Show (partial) command in status line.
set noerrorbells " No annoying sound

" formatting
set tabstop=4
set shiftwidth=4
set expandtab
" do I need this?
retab
set autoindent
set smartindent
set cindent
set colorcolumn=110

" set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

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
" let g:airline_powerline_fonts = 1
" for browsing files
nmap bo :browse oldfiles<CR>

hi Normal guibg=NONE ctermbg=NONE
