" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline segments:
let g:airline_powerline_fonts = 1
"let g:airline_symbols_ascii = 1

" 
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let g:airline_skip_empty_sections = 1
" :echo g:airline_symbols查看符号
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.notexists = '✱'

" See `:echo g:airline_theme_map` for more choices
" `:AirlineTheme <tab>` for more choices
" Default in terminal vim is 'dark'
" molokai solarized
let g:airline_theme = 'deus'

let g:airline#extensions#tabline#enabled = 1
"显示当前tab的窗口数(分裂数)
"let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#tab_nr_type= 2
"只有一个tab时也显示
"let g:airline#extensions#tabline#show_buffers = 0
"显示tab数字总开关
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#buffers_label = 'B'
let g:airline#extensions#tabline#tabs_label = 'T'
"let g:airline#extensions#tabline#tabnr_formatter = 'tabnr'
"TODO:?
"let g:airline#extensions#tabline#show_tab_type = 1
"let g:airline#extensions#tmuxline#enabled = 1

let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
" nmap <leader>1 <Plug>AirlineSelectTab1
" nmap <leader>2 <Plug>AirlineSelectTab2
" nmap <leader>3 <Plug>AirlineSelectTab3
" nmap <leader>4 <Plug>AirlineSelectTab4
" nmap <leader>5 <Plug>AirlineSelectTab5
" nmap <leader>6 <Plug>AirlineSelectTab6
" nmap <leader>7 <Plug>AirlineSelectTab7
" nmap <leader>8 <Plug>AirlineSelectTab8
" nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

" let g:airline#extensions#tabline#buffer_idx_format = {
"    \ '0': '0 ',
"    \ '1': '1 ',
"    \ '2': '2 ',
"    \ '3': '3 ',
"    \ '4': '4 ',
"    \ '5': '5 ',
"    \ '6': '6 ',
"    \ '7': '7 ',
"    \ '8': '8 ',
"    \ '9': '9 '
"    \}
let g:airline#extensions#tabline#show_close_button = 0
"let g:airline#extensions#tabline#close_symbol = 'X'
"let airline#extensions#tabline#disable_refresh = 0

let g:airline_inactive_collapse=0
call airline#parts#define_function('nr', 'winnr')
" call airline#parts#define_accent('nr', 'red')
let g:airline_section_a = airline#section#create(['nr', 'crypt', 'paste', 'spell', 'iminsert'])

let g:airline_filetype_overrides = {
    \ 'defx':  ['%{winnr()}', '%{b:defx.paths[0]}'],
    \ 'help':  ['Help', '%f'],
    \ 'startify': ['%{winnr()}', 'startify'],
    \ }

" let g:NERDTreeStatusline = "%{winnr('$')>1?'['.winnr().']':''}\ "
"      \ ."%{exists('b:NERDTree')?b:NERDTree.root.path.str():''}"
let g:NERDTreeStatusline = airline#section#create(['nr'])

" TODO tagbar状态栏显示还存在问题
"let g:airline#extensions#tagbar#enabled = 1

" TODO part nr 和 'Quickfix' 没有区分开
"let g:airline#extensions#quickfix#quickfix_text = airline#section#create(['nr', ' ', 'Quickfix'])
