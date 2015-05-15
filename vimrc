set t_Co=256

call pathogen#incubate()
call pathogen#infect()
call pathogen#helptags()

syntax on "enable 

colorscheme thomas
set bg=dark


syntax sync minlines=100

if has("gui_running")
	if has("gui_win32")
		set guifont=DejaVu_Sans_Mono:h10:cANSI
	endif
else
	set scrolloff=999
endif

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

set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent

set matchpairs+=<:>

if has("win32")
    "set listchars=tab:>,trail:~,eol:$
else
    set listchars=tab:→\ ,trail:·,eol:$
endif


let s:ostype = system("echo -n $OSTYPE")
if !v:shell_error && s:ostype == "darwin12" " do I need a trailing \n or \r?
"set clipboard=unnamed
endif


autocmd BufRead,BufNewFile *.hs,*.cabal set expandtab
autocmd BufReadPost,BufNewFile SConstruct,SConscript set filetype=python


"noremap ;; ;
noremap ; :

nnoremap Y y$

noremap K <Nop>
noremap M <Nop>
noremap Q <Nop>
nnoremap <F1> <nop>

command WQ wq
command Wq wq
command W w
command Q q


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""\
"""""""           |
""               [ ]
"               [   ]
"              [     ]
"              \     /


set timeout " Do time out on mappings and others
set timeoutlen=2000 " Wait {num} ms before timing out a mapping

" When you’re pressing Escape to leave insert mode in the terminal, it will by
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

















