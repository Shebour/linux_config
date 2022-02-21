filetype plugin on
filetype plugin indent on

call plug#begin()
"""""""""""""""""""""""
"" Add new plugins here
"""""""""""""""""""""""
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
""Plug 'valloric/youcompleteme'
Plug 'flazz/vim-colorschemes'
Plug 'rhysd/vim-clang-format'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim'
"""""""""""""""""""""""
"" End of plugin list
"""""""""""""""""""""""
call plug#end()

let g:lightline = {'colorscheme' : 'gruvbox'}

set number
set mouse=a
set belloff=all
set cc=80
set expandtab
set nocompatible
set encoding=utf-8 fileencodings=
set clipboard=unnamed
set shiftwidth=4
set softtabstop=4
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

let &t_SI = "\<esc>[6 q"  " solid I-beam in insert mode
let &t_SR = "\<esc>[4 q"  " solid underline in replace mode
let &t_EI = "\<esc>[2 q"  " default cursor solid block otherwise

command W w
command Q q
command Wq wq
command WQ wq

inoreabbrev #i #include
inoreabbrev #d #define
inoreabbrev #p #pragma
inoreabbrev st struct

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
" CoC
set hidden
set cmdheight=2 " recomand 2
set shortmess+=c


" let g:coc_confing_home = '~/path/to/coc-settings.json'
let g:coc_global_extensions = [
            \ 'coc-prettier',
            \ 'coc-json',
            \ 'coc-sh',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-pyright',
            \ 'coc-java',
            \ 'coc-cmake',
            \ 'coc-vimlsp',
            \ 'coc-clangd',
            \ ]

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>r <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
