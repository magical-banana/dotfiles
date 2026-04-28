" --- Plugin Section ---
call plug#begin('~/.vim/plugged')

" Essentials
Plug 'tpope/vim-sensible'          " Better defaults
Plug 'itchyny/lightline.vim'       " Lightweight status bar (no heavy deps)
Plug 'airblade/vim-gitgutter'      " Shows git diffs (+/-) in the gutter
Plug 'tpope/vim-commentary'       " Quick commenting (gc to comment)

" DevOps / Language Support
Plug 'stephpy/vim-yaml'            " Better YAML highlighting
Plug 'hashivim/vim-terraform'      " Terraform support
Plug 'fatih/vim-go'                " Go support (since you use Go)

" Fuzzy Finding (uses the fzf you installed via mise)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Theme — Gotham (whatyouhide/vim-gotham)
" Ships its own lightline colorscheme as autoload/lightline/colorscheme/gotham.vim
Plug 'whatyouhide/vim-gotham'

call plug#end()

" --- Theme activation ---
" Must come AFTER plug#end() so the colorscheme is loaded.
" `silent!` so vim doesn't error on first launch (before PlugInstall has run).
silent! colorscheme gotham

" --- General Settings ---
set nocompatible            " Use Vim defaults instead of Vi
set encoding=utf-8          " Standard encoding
set number                  " Show line numbers
set relativenumber          " Great for jumping lines quickly (e.g., 5j)
set mouse=a                 " Enable mouse support for scrolling/selection
" System clipboard — `unnamedplus` requires +clipboard. On WSL, vim won't
" find a clipboard provider by default, so we proxy yanks through clip.exe.
set clipboard=unnamedplus
if !empty($WSL_DISTRO_NAME) || (filereadable('/proc/version') && match(readfile('/proc/version'), '\cmicrosoft\|wsl') >= 0)
    if executable('clip.exe')
        augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system('clip.exe', join(v:event.regcontents, "\n")) | endif
        augroup END
    endif
endif
set hidden                  " Switch buffers without saving
set noswapfile              " Skip swap files (we save often anyway)

" --- Search ---
set ignorecase              " Ignore case in search patterns
set smartcase               " ...unless search contains a capital letter
set hlsearch                " Highlight search results
set incsearch               " Incremental search

" --- UI/Visuals ---
syntax on                   " Enable syntax highlighting
set cursorline              " Highlight the line the cursor is on
set showmatch               " Show matching brackets
set termguicolors           " Better color support in modern terminals
set colorcolumn=100         " Guideline for line length (good for PRs)

" --- Indentation (DevOps/YAML friendly) ---
set expandtab               " Use spaces instead of tabs
set shiftwidth=2            " 1 tab = 2 spaces (standard for YAML/Terraform)
set softtabstop=2           " Affects backspace behavior
set autoindent
set smartindent

" --- Filetype specific (Keep YAML/Python happy) ---
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

" --- Key Remaps ---
let mapleader = " "         " Space as leader key is very ergonomic
" Clear highlights with Leader + L
nnoremap <leader>l :nohlsearch<CR>
" Faster saving
nnoremap <leader>w :w<CR>
" Split navigation (Ctrl + h/j/k/l)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Visibility (Show trailing whitespace/tabs) ---
set list
set listchars=tab:▸\ ,trail:·

" Lightline config (makes it look nice)
set laststatus=2
let g:lightline = {'colorscheme': 'gotham'}

" Ignore Go version warning"
let g:go_version_warning = 0