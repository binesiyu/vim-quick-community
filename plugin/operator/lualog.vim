if exists('g:loaded_operator_lualog')
  finish
endif

call operator#user#define('luadump',    'operator#lualog#luadump')
call operator#user#define('luaprint',   'operator#lualog#luaprint')
call operator#user#define('luadumpbefore',    'operator#lualog#luadumpbefore')
call operator#user#define('luaprintbefore',   'operator#lualog#luaprintbefore')
call operator#user#define('helpgrep', 'operator#lualog#helpgrep')
call operator#user#define('dash',     'operator#lualog#dash')

let g:loaded_operator_lualog = 1
