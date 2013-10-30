set nocp
set ml
set modelines=5

"Pathogen
call pathogen#infect()
filetype off
syntax on
filetype plugin indent on
call pathogen#helptags()

set clipboard+=unnamed
set pastetoggle=<f4>
colorscheme idleFingers
set laststatus=2
set showmode
set ch=2
set wildmenu
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpe?g,*.png,*.xpm,*.gif,*.pyc
set incsearch
nmap <F5> :set number! number?<CR>

" with which keys to wrap text
set whichwrap+=<,>,h,l,[,]
" exit with jj
imap jj <ESC>

" map ctrl arrow keys
" ctrl right
map <ESC>[1;5C w
" ctrl down
map <ESC>[1;5B j
" ctrl left
map <ESC>[1;5D b
" ctrl up
map <ESC>[1;5A k

" delete word backwards
map <ESC>[3;5~ bdaw
