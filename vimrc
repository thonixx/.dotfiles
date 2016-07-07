" I WANT EVERYTHING IN UTF-8
scriptencoding utf-8

" more utf8 stuff
set encoding=utf-8

" i want vim and not vi, so turn off compatible stuff
set nocp

" enable modeline ..
set ml

" .. and check certain lines
set modelines=5

" highlight search occurrences
set hlsearch

" i want to delete indents and over the start of insert
set backspace=indent,start

" some clipboard magic
set clipboard+=unnamed

" paste mode with key combo
set pastetoggle=<f4>

" i always want a status line
set laststatus=2

" show the mode
set showmode

" more space for commands
set ch=2

" autocomplete ..
set wildmenu

" .. but not everything
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpe?g,*.png,*.xpm,*.gif,*.pyc

" incremental search
set incsearch

" my vim theme
colorscheme idleFingers

" with which keys to wrap text
set whichwrap+=<,>,h,l,[,]

" foldlevel setting
set foldlevel=999

" non-printable chars ..
set list

" .. and their appearance
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•

" set line numbering
set number

" mouse mode in insert mode only
set mouse=i

"""""""""""""""""""""" keymapping in command mode only

" enable/disable line numbering
map <F5> :set number! number?<CR>

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

" save with ESC ESC
map <Esc><Esc> :w<CR>

" jump to eol with \ (way more comfortable with US layout
map \ $

"""""""""""""""""""""" END OF keymapping in command mode only
"""""""""""""""""""""" keymapping in insert mode only

" save file with a combo in insert mode
imap <c-x> <c-o>:w<cr>

" fast exit with jj
imap jj <ESC>

" save with ESC ESC in insert mode
imap <Esc><Esc> <Esc>:w<CR>a

" save and exit with Ctrl-X Ctrl-X
imap <c-x><c-x> <Esc>:wq<CR>

"""""""""""""""""""""" END OF keymapping in insert mode only

" Strip trailing whitespace (,ss)
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"Pathogen syntax highlighting things
call pathogen#infect()
filetype off
syntax on
let g:syntastic_puppet_puppetlint_args = "--no-80chars-check"
filetype plugin indent on
call pathogen#helptags()

" source local config
fun! SomeCheck()
  if filereadable("~/.vim/vimrc.local")
    so ~/.vim/vimrc.local
  endif
endfun

