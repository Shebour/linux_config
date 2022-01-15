set rtp+=~/.vim/bundle/Vundle.vim
filetype plugin on
filetype plugin indent on

call vundle#begin()
"""""""""""""""""""""""
"" Add new plugins here
"""""""""""""""""""""""
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'joshdick/onedark.vim'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'morhetz/gruvbox'
Plugin 'valloric/youcompleteme'
Plugin 'flazz/vim-colorschemes'
Plugin 'rhysd/vim-clang-format'
Plugin 'sheerun/vim-polyglot'
Plugin 'wsdjeg/vim-assembly'
Plugin 'dbext.vim'
"""""""""""""""""""""""
"" End of plugin list
"""""""""""""""""""""""
call vundle#end()

let g:lightline = {'colorscheme' : 'gruvbox'}
colorscheme gruvbox

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

map <C-o> :NERDTreeToggle<CR>
map <C-m> :GitGutterToggle<CR>

inoremap { {}<ESC>ha
inoremap [ []<Esc>ha
inoremap ( ()<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha

let g:clang_format#detect_style_file = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:ycm_autoclose_preview_window_after_completion=1
let g:clang_library_path='/usr/lib64/libclang.so.3.8'

autocmd FileType c ClangFormatAutoEnable
syntax on

set number
set mouse=a
set belloff=all
set cc=80
set nocompatible
set encoding=utf-8 fileencodings=
set clipboard=unnamed
set shiftwidth=4
set tabstop=4
set expandtab
set smartindent
set autoindent
set fileformat=unix
set list listchars=tab:»\ ,trail:·
set updatetime=100
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set cinoptions+=:0
set cursorline

