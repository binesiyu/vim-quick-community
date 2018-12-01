" default values for settings {{{
function! operator#lualog#luadump(motion_wise)
  call s:log_cmd('dump(%s,"%s",10)',"o", a:motion_wise)
endfunction

function! operator#lualog#luadumpbefore(motion_wise)
  call s:log_cmd('dump(%s,"%s",10)',"O", a:motion_wise)
endfunction

function! operator#lualog#luaprint(motion_wise)
  call s:log_cmd('print(%s,"%s")',"o", a:motion_wise)
endfunction

function! operator#lualog#luaprintbefore(motion_wise)
  call s:log_cmd('print(%s,"%s")',"O", a:motion_wise)
endfunction

function! operator#lualog#dash(motion_wise)
  call s:search_cmd('Dash', a:motion_wise)
endfunction

function! operator#lualog#helpgrep(motion_wise)
  call s:search_cmd('helpgrep', a:motion_wise)
endfunction
"}}}
" internal {{{
function! s:log_cmd(cmd,putcmd,motion_wise)
  " execute a:cmd . ' ' . fnameescape(s:operator_sel(a:motion_wise))
  let l:sel = fnameescape(s:operator_sel(a:motion_wise))
  let l:strStl = printf(a:cmd,l:sel,l:sel)
  execute "normal " . a:putcmd . l:strStl
endfunction

function! s:search_cmd(cmd, motion_wise)
  execute a:cmd . ' ' . fnameescape(s:operator_sel(a:motion_wise))
endfunction

function! s:operator_sel(motion_wise)
  let v = operator#user#visual_command_from_wise_name(a:motion_wise)
  let [save_reg_k, save_regtype_k] = [getreg('k'), getregtype('k')]
  try
    execute 'normal!' '`[' . v . '`]"ky'
    " return s:get_visual_selection()
    return getreg('k')
  finally
    call setreg('k', save_reg_k, save_regtype_k)
  endtry
endfunction

" Stolen from: http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
" currently not used as we are pasting to a random register instead
function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction
"}}}

