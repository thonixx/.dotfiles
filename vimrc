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
"set cpoptions=B$

set whichwrap+=<,>,h,l,[,]
