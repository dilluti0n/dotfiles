set encoding=utf-8

set autoindent
set smartindent

" indent = 4 space
set tabstop=4
set shiftwidth=4
set expandtab

set number
set relativenumber

set laststatus=2
syntax enable

set ignorecase
set smartcase

" search highlight
set hlsearch
" show commands
set showcmd

if has("gui_running")
    set guifont=Iosevka\ 20
    colorscheme slate
endif
