set encoding=utf-8

set autoindent
set smartindent

" indent = 4 space
set tabstop=4
set shiftwidth=4
set expandtab

set number
" set relativenumber

set laststatus=2
syntax enable

set ignorecase
set smartcase

" search highlight
set nohlsearch
" show commands
set showcmd

if has("gui_running")
    set guifont=Iosevka\ 20
    colorscheme slate
endif

filetype off
set shell=/bin/sh
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'
"	Plugin 'vim-airline/vim-airline'
"	Plugin 'vim-airline/vim-airline-themes'
"   Plugin 'morhetz/gruvbox'
call vundle#end()
filetype plugin indent on

" set colorscheme
" colorscheme gruvbox

" gruvbox
"set background=dark
"let g:gruvbox_contrast_dark = 'soft'
"let g:gruvbox_italic = 1

