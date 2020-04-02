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
Plugin 'tpope/vim-commentary' " for easy commenting -gc
Plugin 'mboughaba/i3config.vim' " syntax highlighting for i3 config file
Plugin 'vim-airline/vim-airline' " for pretty bar
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jreybert/vimagit' " git operations in few key press
Plugin 'scrooloose/nerdtree'
Plugin 'vimwiki/vimwiki'
Plugin 'mbbill/undotree'
Plugin 'universal-ctags/ctags'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8
set clipboard=unnamedplus " for easy copy pasting
set number relativenumber
" searching
set incsearch

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

" Replace ex mode with gq
	map Q gq


" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	" map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	" autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

" " When shortcut files are updated, renew bash and ranger configs with new material:
" 	autocmd BufWritePost files,directories !shortcuts
" " Run xrdb whenever Xdefaults or Xresources are updated.
" 	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" " Update binds when sxhkdrc is updated.
" 	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
" if &diff
"     highlight! link DiffText MatchParen
" endif

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
let g:airline_powerline_fonts = 1
" for browsing files
nmap bo :browse oldfiles<CR>
