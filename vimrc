scriptencoding utf-8
set encoding=utf-8

set nocp
set ml
set modelines=5

"Pathogen syntax highlighting things
call pathogen#infect()
filetype off
syntax on
let g:syntastic_puppet_puppetlint_args = "--no-80chars-check"
filetype plugin indent on
call pathogen#helptags()

set clipboard+=unnamed
set pastetoggle=<f4>
" my vim theme
colorscheme idleFingers
set laststatus=2
set showmode
set ch=2
set wildmenu
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpe?g,*.png,*.xpm,*.gif,*.pyc
set incsearch
" enable/disable line numbering
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

" save with c-x in insert mode
imap <c-x> <c-o>:w<cr>

" foldlevel setting
set foldlevel=999

" non-printable chars
set list
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•

" set line numbering
set number

" save with ESC ESC
map <Esc><Esc> :w<CR>

" save with ESC ESC in insert mode
imap <Esc><Esc> <Esc>:w<CR>a

" save and exit with Ctrl-X Ctrl-X
imap <c-x><c-x> <Esc>:wq<CR>

" jump to eol with \
map \ $

" mouse mode to insert mode only
set mouse=i

" source local config
function! SomeCheck()
  if filereadable("~/.vim/vimrc.local")
    so ~/.vim/vimrc.local
  endif
endfunction

" Strip trailing whitespace (,ss)
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
