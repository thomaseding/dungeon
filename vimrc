set t_Co=256

call pathogen#incubate()
call pathogen#infect()
call pathogen#helptags()

syntax on "enable 

if hostname() == "the-law"
	colorscheme calmar256-thomas
	set bg=dark
else
	colorscheme desert
	set bg=dark
endif


syntax sync minlines=100


set scrolloff=999

set nocursorcolumn
set nocursorline

set number
set relativenumber

set ruler
set noswapfile
set nowritebackup
set nobackup

set nowrap


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

if has("win32")
    "set listchars=tab:>,trail:~,eol:$
else
    set listchars=tab:→\ ,trail:·,eol:$
endif


let s:ostype = system("echo -n $OSTYPE")
if !v:shell_error && s:ostype == "darwin12" " do I need a trailing \n or \r?
"set clipboard=unnamed
endif


"noremap ;; ;
noremap ; :





autocmd BufRead,BufNewFile *.hs,*.cabal set expandtab









