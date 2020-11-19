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
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary' " for easy commenting -gc
Plugin 'mboughaba/i3config.vim' " syntax highlighting for i3 config file
Plugin 'vim-airline/vim-airline' " for pretty bar
Plugin 'jreybert/vimagit' " git operations in few key press
Plugin 'scrooloose/nerdtree'
Plugin 'mbbill/undotree'
Plugin 'universal-ctags/ctags'
Plugin 'morhetz/gruvbox'
Plugin 'junegunn/fzf.vim'
" Peekaboo extends " and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers.
Plugin 'junegunn/vim-peekaboo'
Plugin 'lervag/vimtex'
Plugin 'KeitaNakamura/tex-conceal.vim'
Plugin 'sirver/ultisnips'
Plugin 'tridactyl/vim-tridactyl'
" https://castel.dev/post/lecture-notes-1/

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

let g:peekaboo_window='vert bo 60new'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"  defaults
set encoding=utf-8
set clipboard=unnamedplus " for easy copy pasting
set number relativenumber
" searching
set incsearch
set hlsearch
set path+=**
set inccommand=nosplit

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
" Is this line needed https://stackoverflow.com/a/1037182/9926721
nnoremap <esc>^[ <esc>^[

command! MakeTags !ctags -R .

" adds fancy colors, for eyes
syntax on

set background=dark
colorscheme gruvbox

hi Normal ctermbg=NONE guibg=NONE
hi Normal guibg=NONE ctermbg=NONE

" highlight Normal ctermbg=Black
" highlight NonText ctermbg=Black

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright
" Nerd tree
" map <leader>n :NERDTreeToggle<CR>
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Shift to the next round tab stop.
set shiftround
" Set auto indent spacing.
set shiftwidth=2

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

set showmode
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Make zathura default view and latex default tex flavor
" let g:vimtex_view_method = 'zathura'
let g:tex_flavor = 'latex'
let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : 'build',
            \}

" nnoremap <C-p> :Files<CR>
" nnoremap <C-o> :Buffers<CR>
" nnoremap <C-g> :GFiles<CR>
" nnoremap <C-f> :Rg
