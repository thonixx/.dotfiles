""""""""""""""""""""""""""""""""""""""""""""""""
"""" begining of the file
" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
" map ctrl-] to enter in normal mode only for this buffer
nnoremap <buffer><cr> <c-]>
" map ctrl-T to backspace in normal mode only for this buffer
nnoremap <buffer><bs> <c-T>
nnoremap <buffer><c-?> <c-T>
"""" End of the file
""""""""""""""""""""""""""""""""""""""""""""""""
