" ======== binding key to run Quick Player for the project of this Lua file.====
" Check if Vim support Python
if (exists('g:loaded_quickplayer') && g:loaded_quickplayer)
  finish
endif

let g:loaded_quickplayer = 1

if !has('python3')
    echo "Error: Run Player Required vim compiled with +python3"
   	echo "Vim for Windows,please check Python & Vim both are 32bit version!"
    finish
endif

" commands {{{
command! RunPlayer call quickplayer#RunPlayer("true")

map <F5> :call quickplayer#RunPlayer("true")<CR>
map <F6> :call quickplayer#RunPlayer("false")<CR>
" }}}

" vim:ts=4:sw=4:sts=4 et fdm=marker:
