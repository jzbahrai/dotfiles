" Setting up pathogen
" execute pathogen#infect()
syntax on
set encoding=utf-8
filetype plugin indent on
set nocompatible
set t_Co=256
set runtimepath+=~/.vim/bundle/Vundle.vim

"Using vundle to manage plugins
call vundle#begin()
Plugin 'justincampbell/vim-eighties'
Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree' 
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'jistr/vim-nerdtree-tabs' "tabs
Plugin 'kien/ctrlp.vim'
Plugin 'klen/python-mode.git'
Plugin 'morhetz/gruvbox'
call vundle#end()            " required

"export PATH=/usr/pgsql-9.4/bin:$PATH

"Using simplyfold for folding vim functions.
"Use zc- close a fold, zo - open a fold
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

"Using eighties-vim
let g:eighties_enabled = 1
let g:eighties_minimum_width = 80
let g:eighties_extra_width = 0 " Increase this if you want some extra room
let g:eighties_compute = 1 " Disable this if you just want the minimum + extra
let g:eighties_bufname_additional_patterns = ['fugitiveblame'] " Defaults to [], 'fugitiveblame' is only an example. Takes a comma delimited list of bufnames as strings.


"Using syntastic for python-syntax checking
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_python_checkers = ['pylint', 'flake8']

if !&scrolloff
    set scrolloff=1
endif
if !&sidescrolloff
    set sidescrolloff=5
endif


" Pymode {
" Disable if python support not present
if !has('python')
    let g:pymode = 0
endif

if isdirectory(expand("~/.vim/bundle/python-mode"))
    let g:pymode_lint_checkers = ['pylint', 'flake8', 'pyflakes']
    let g:pymode_trim_whitespaces = 0
    let g:pymode_options = 0
    let g:pymode_rope =0
endif
" }

"Using nerdtree and its git plugin
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-m> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

"Ctrlp - this is beautiful
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"pymode plugin
" PyMode {
" Disable if python support not present

if isdirectory(expand("~/.vim/bundle/python-mode"))
    let g:pymode_lint_checkers = ['pyflakes']
    let g:pymode_trim_whitespaces = 0
    let g:pymode_options = 0
    let g:pymode_rope = 0
endif
" }


let python_highlight_all=1
syntax on

"Setting background color either solarized or zenburn
if has('gui_running')
    set background=dark
    colorscheme gruvbox
else
    set background=dark
    colorscheme gruvbox
endif

filetype plugin on
filetype indent on
set foldmethod=indent
set foldlevel=99
syntax enable
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set laststatus=2
set autoindent
set nu
set hidden
set backspace=2
set showcmd
set wildmenu
set autoread
set visualbell
set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4
set shiftround
set hlsearch
set incsearch
set ignorecase
set smartcase
set ruler
set ts=4
set autoindent
set shiftwidth=4
set showmatch
"set colorcolumn=80,120
if exists('+colorcolumn')
    set colorcolumn=80,120
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
set cursorline
set spell

vnoremap <C-l> >gv
vnoremap <C-l> <gv



py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"    execfile(activate_this, dict(__file__=activate_this))
EOF
