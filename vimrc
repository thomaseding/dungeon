" Hide buggy system "matchparen" so corrected user version
" can be used instead.
"
" https://vi.stackexchange.com/q/18701
"
" Link for file with fixed bug:
" https://github.com/vim/vim/blob/master/runtime/plugin/matchparen.vim
let g:loaded_matchparen = 1

execute pathogen#infect()
syntax on
filetype plugin indent on

colorscheme thomas
"set bg=dark

syntax sync minlines=300

set sidescroll=1

set nocursorcolumn
set nocursorline

set number
set relativenumber

set ruler
set noswapfile
set nowritebackup
set nobackup

set nowrap

set splitbelow
set splitright

set backspace=eol,start,indent

set ignorecase
set smartcase
set hlsearch

"set statusline
set statusline=%<%m\ %f\ %y\ %{&ff}\ \%=\ row:%l\ of\ %L\ col:%c%V\ %P

set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent

set matchpairs+=<:>

set mouse+=a

"set clipboard=unnamedplus

" https://vim.fandom.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

autocmd BufRead,BufNewFile *.hs,*.cabal set expandtab

"augroup fmt
	"autocmd!
	"autocmd BufWritePre *.hs try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
"augroup END

noremap ; :

nnoremap Y y$

noremap K <Nop>
noremap M <Nop>
noremap Q <Nop>
nnoremap <F1> <nop>


nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>
nnoremap <3-MiddleMouse> <Nop>
nnoremap <4-MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>
inoremap <2-MiddleMouse> <Nop>
inoremap <3-MiddleMouse> <Nop>
inoremap <4-MiddleMouse> <Nop>


command WQ wq
command Wq wq
command W w
command Q q




"highlight Underscore cterm=bold
"match Underscore /_/
"au InsertEnter * match Underscore /_/
"au InsertLeave * match Underscore /_/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""\
"""""""           |
""               [ ]
"               [   ]
"              [     ]
"              \     /


set timeout " Do time out on mappings and others
set timeoutlen=2000 " Wait {num} ms before timing out a mapping

" When you're pressing Escape to leave insert mode in the terminal, it will by
" default take a second or another keystroke to leave insert mode completely
" and update the statusline. This fixes that. I got this from:
" https://powerline.readthedocs.org/en/latest/tipstricks.html#vim
if !has('gui_running')
        set ttimeoutlen=10
        augroup FastEscape
                autocmd!
                au InsertEnter * set timeoutlen=0
                au InsertLeave * set timeoutlen=1000
        augroup END
endif

"              /     \
"              [     ]
"               [   ]
""               [ ]
"""""""           |
""""""""""""""""""/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""





" Disable syntax when using vim as a difftool.
if &diff
    syntax off
endif


