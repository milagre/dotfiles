set nocompatible              " be iMproved, required
filetype off                  " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'flazz/vim-colorschemes'
Plugin 'txt.vim'
"Plugin 'Syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'b4winckler/vim-angry'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'tpope/vim-commentary'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Aliases/Helpers
:command! Reload so %

" Keymaps
nnoremap J :tabprevious<CR>
nnoremap K :tabnext<CR>
nnoremap <C-j> :join<CR>
nnoremap <C-f> :let @/ = @"<CR>|  " Find yanked text
set pastetoggle=<F2>

" Vim settings
set clipboard=unnamed
set hidden|     " Let user switch away from buffers with unsaved changes
set hlsearch    " Highlight search term matches

" Display settings
set number
set guifont=Consolas:h11:cANSI| " Fix molokai italics/gui only
set cursorline
if has("gui_running")
    colorscheme molokai
else
    set background=dark
endif

" Spacing and tabbing
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=100
set nowrap
   
" Filetypes
autocmd BufEnter,BufRead,BufNewFile *.txt setfiletype txt

" Autocmd utilities
autocmd BufEnter * silent! lcd %:p:h|                           " cd to opened file location
autocmd FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>")|     " Normal mode on focus lost

" NerdTree Settings
autocmd VimEnter * nmap <F3> :NERDTreeToggle<CR>
autocmd VimEnter * imap <F3> <Esc>:NERDTreeToggle<CR>a
let NERDTreeQuitOnOpen=1
let NERDTreeWinSize=50

" Ctrl-P Settings
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd = 'CtrlPMRU'|  " Start Ctrl P in MRU mode
