" vim: set sw=2 sts=4 et tw=78 foldmarker=, foldlevel=0 foldmethod=marker:

" Don't override colorscheme.
if !exists('g:colors_name')
  "colorscheme gruvbox
  " https://github.com/morhetz/gruvbox/wiki/Configuration
  "let g:gruvbox_italicize_comments = 0
  "let g:gruvbox_italic = 0
  " candy256
  "set background=dark " for the dark version
  "colorscheme one
  colorscheme onedark
endif

" Encoding: 
" The automatic recognition of the character code.

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac

" Command group opening with a specific character code again.
" In particular effective when I am garbled in a terminal.
" Open in UTF-8(cp65001) again.
command! -bang -bar -complete=file -nargs=? Utf8
      \ edit<bang> ++enc=utf-8 <args>
" Open in GB18030 again.
command! -bang -bar -complete=file -nargs=? GB18030
      \ edit<bang> ++enc=cp54936 <args>
" Open in GB2312 again.
command! -bang -bar -complete=file -nargs=? Cp936
      \ edit<bang> ++enc=cp936 <args>
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16
      \ edit<bang> ++enc=ucs-2le <args>
" Open in latin1 again.
command! -bang -bar -complete=file -nargs=? Latin
      \ edit<bang> ++enc=latin1 <args>

" Tried to make a file note version.
command! WUtf8 setlocal fenc=utf-8
command! WCp936 setlocal fenc=cp936
command! WLatin1 setlocal fenc=latin1

" Appoint a line feed.
command! -bang -complete=file -nargs=? WUnix
      \ write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos
      \ write<bang> ++fileformat=dos <args> | edit <args>

function! China() abort
  silent! %s/（/(/g
  silent! %s/）/)/g
  silent! %s/，/, /g
  silent! %s/。/. /g
  silent! %s/：/: /g
  silent! %s/；/; /g
endfunction
" 

" options 
set printoptions=header:0

"---------------------------------------------------------------------------
" Search:

" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch
" Disable highlight search result.
set nohlsearch

" Searches wrap around the end of the file.
set wrapscan


"---------------------------------------------------------------------------
" Edit:

" Smart insert tab setting.
set smarttab
" 展开 tab
set expandtab
" 设置制表位
set tabstop=4
" 软件使空格实现制表位行为
set softtabstop=4
" Autoindent width.
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable smart indent.
set autoindent smartindent

function! GnuIndent()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
  setlocal noexpandtab
endfunction

" Disable modeline.
" set modelines=0
" set nomodeline
" autocmd MyAutoCmd BufRead,BufWritePost *.txt setlocal modelines=5 modeline

" Use clipboard register.
" TODO: 猜测 $DISPLAY 不为空表明X server正在工作
" TODO: vim clipboard exclude模式
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
  if has('unnamedplus')
    " quoteplus is the X server clipboard
    " set clipboard& clipboard+=unnamedplus
    set clipboard=unnamedplus
  else
    set clipboard& clipboard+=unnamed
  endif
endif
if has('nvim')
  set clipboard& clipboard+=unnamedplus
endif

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
set hidden

" Search home directory path on cd.
" But can't complete.
" set cdpath+=~

" foldenable default on
set foldmethod=indent
set foldlevel=9
" Show folding level.
"set foldcolumn=1
set fillchars=vert:\│

" FastFold
"autocmd MyAutoCmd TextChangedI,TextChanged *
"      \ if &l:foldenable && &l:foldmethod !=# 'manual' |
"      \   let b:foldmethod_save = &l:foldmethod |
"      \   let &l:foldmethod = 'manual' |
"      \ endif
"autocmd MyAutoCmd BufWritePost *
"      \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
"      \   let &l:foldmethod = b:foldmethod_save |
"      \   execute 'normal! zx' |
"      \ endif

" function! MyFoldText()
"   let line = v:foldstart
"   let line .= " + "
"   let end = v:foldend - v:foldstart
"   let line .= end
"   let line .= " "
"   let line .= getline(v:foldstart)
"   let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
"   return v:folddashes.sub
" endfunction
"set foldtext=MyFoldText()

let defaults = {'placeholder': '...', 'line': 'L', 'multiplication': '*' }
let g:FoldText_placeholder    = get(g:, 'FoldText_placeholder',    defaults['placeholder'])
let g:FoldText_line           = get(g:, 'FoldText_line',           defaults['line'])
let g:FoldText_multiplication = get(g:, 'FoldText_multiplication', defaults['multiplication'])
let g:FoldText_gap            = get(g:, 'FoldText_gap',            4)
let g:FoldText_info           = get(g:, 'FoldText_info',           1)
unlet defaults

function! FoldText()
  let fs = v:foldstart
  " TODO v:foldstart可能是空行吗
  " while getline(fs) =~ '^\s*$'
  "   let fs = nextnonblank(fs + 1)
  " endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let spaces = repeat(' ', &tabstop)
    let line = substitute(getline(fs), '\t', spaces, 'g')
  endif

  let endBlockChars   = ['end', '}', ']', ')', '})', '},', '}}}']
  let endBlockRegex = printf('^\(\s*\|\s*\"\s*\)\(%s\);\?$', join(endBlockChars, '\|'))
  let endCommentRegex = '\s*\*/$'
  let startCommentBlankRegex = '\v^\s*/\*!?\s*$'

  let foldEnding = strpart(getline(v:foldend), indent(v:foldend), 3)

  if foldEnding =~ endBlockRegex
    if foldEnding =~ '^\s*\"'
      let foldEnding = strpart(getline(v:foldend), indent(v:foldend)+2, 3)
    end
    let foldEnding = " " . g:FoldText_placeholder . " " . foldEnding
  elseif foldEnding =~ endCommentRegex
    if getline(v:foldstart) =~ startCommentBlankRegex
      let nextLine = substitute(getline(v:foldstart + 1), '\v\s*\*', '', '')
      let line = line . nextLine
    endif
    let foldEnding = " " . g:FoldText_placeholder . " " . foldEnding
  else
    let foldEnding = " " . g:FoldText_placeholder
  endif

  let foldColumnWidth = (&foldcolumn ? &foldcolumn : 0) + (get(g:, 'gitgutter_enabled', 0) ? 3 : 0)
  let numberColumnWidth = &number ? strwidth(line('$')) : 0
  let width = winwidth(0) - foldColumnWidth - numberColumnWidth

  let ending = ""
  if g:FoldText_info
    let foldSize = 1 + v:foldend - v:foldstart
    let ending = printf("%s%s", g:FoldText_multiplication, foldSize)
    let ending = printf("%s%-6s", g:FoldText_line, ending)

    if strwidth(line . foldEnding . ending) >= width
      let line = strpart(line, 0, width - strwidth(foldEnding . ending))
    endif
  endif

  let expansionStr = repeat(" ", width - g:FoldText_gap - strwidth(line . foldEnding . ending))
  return line . foldEnding . expansionStr . ending
endfunction
set foldtext=FoldText()

" exists('*funcname')

" Use vimgrep.
" set grepprg=internal
" Use grep.
"set grepprg=grep\ -inH

" Exclude = from isfilename.
set isfname-==

" key code or mapped key sequence timeout(ms)
set timeout timeoutlen=800 ttimeoutlen=100

" CursorHold time.
set updatetime=1000

" Set swap directory.
set directory-=.

" Set undofile.
set undofile
let &g:undodir = &directory

" Enable virtualedit in visual block mode.
set virtualedit=block

" Set keyword help.
set keywordprg=:help

" Check timestamp more for 'autoread'.
autocmd MyAutoCmd WinEnter * checktime
" Disable paste.
autocmd MyAutoCmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
    \ if &l:diff | diffupdate | endif

" Update diff.
autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" Make directory automatically.
" --------------------------------------
" http://vim-users.jp/2011/02/hack202/

autocmd MyAutoCmd BufWritePre *
      \ call s:mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
function! s:mkdir_as_necessary(dir, force) abort
  if !isdirectory(a:dir) && &l:buftype == '' &&
        \ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
        \              a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

" Use blowfish2
" https://dgl.cx/2014/10/vim-blowfish
" if has('cryptv')
" It seems 15ms overhead.
"  set cryptmethod=blowfish2
" endif

" :h :set-&
" If true Vim master, use English help file.
set helplang& helplang=en,cn

" Default home directory.
let t:cwd = getcwd()

"---------------------------------------------------------------------------
" View:
"

if has('nvim')
  set signcolumn=auto:4
else
  set ttyfast
endif
let s:ftIgnore = ['defx', 'denite', 'denite-filter', 'translator_border', 'translator']

autocmd MyAutoCmd FileType *
  \ if !count(s:ftIgnore, &ft)
  \|  set number relativenumber
  \|endif

" Show <TAB> and <CR>
set list
if has('nvim')
  autocmd MyAutoCmd TermOpen * setl nolist
else
  autocmd MyAutoCmd TerminalOpen * setl nolist
endif
if g:Windows
  set listchars=tab:>-,trail:-,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:•,extends:»,precedes:«,nbsp:%
endif
" Always display statusline.
set laststatus=2
" Height of command line.
set cmdheight=1
" No show command in the last line.
set noshowcmd
" Show title.
set title
" Title length.
set titlelen=95
" TODO Title string.
let &g:titlestring="
      \ %{expand('%:p:~:.')}%(%m%r%w%)
      \ %<\(%{WidthPart(
      \ fnamemodify(&filetype ==# 'vimfiler' ?
      \ substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),
      \ &columns-len(expand('%:p:.:~')))}\) - VIM"
" Disable tabline.
"set showtabline=0

" let-&设置的优点: 不需要反斜杠转义空格
" TODO 原来的设置不能及时刷新
" "%{winnr('$')>1?'['.winnr().'/'.winnr('$').(winnr('#')==winnr()?'#':'').']':''}\ "
"let &g:statusline="%{winnr('$')>1?'['.winnr().']':''}\ "
"      \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}%m"
"      \ . "%=%{(winnr('$')==1 || winnr('#')!=winnr()) ? '['.(&filetype!=''?&filetype.',':'')"
"      \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
"      \ . "%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

" Turn down a long line appointed in 'breakat'
set linebreak
" TODO 还不能理解breakat的行为
set breakat=\ \	;:,!?
" Wrap(回绕) 键.
set whichwrap+=h,l,<,>,[,],b,s,~
" showwrap更恰当
" set showbreak=\
if exists('+breakindent')
  set breakindent
  set nowrap
else
  set nowrap
endif

" Do not display the greetings message at the time of Vim start.
set shortmess=aTI

" Do not display the completion messages
set noshowmode
set shortmess+=c

" Do not display the edit messages
set shortmess+=F

" Don't create backup.
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

" Disable bell.
set t_vb=
set novisualbell
set belloff=all

" Display candidate supplement.
" set nowildmenu
" set wildmode=list:longest,full
" Increase history amount.
set history=1000
" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
if !has('nvim')
  " Can supplement a tag in a command-line.
  set wildoptions=tagfile
endif

set viminfo=!,'300,<50,s10,h

" Disable menu
let g:did_install_default_menus = 1

" Completion setting.
set completeopt=menuone
set completeopt+=noinsert

" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=20

" Report changes.
set report=0

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width/height for current window.
set winwidth=30 winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways

" window height of preview and help.
set previewheight=12
set helpheight=12

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

function! WidthPart(str, width) abort
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction

" For conceal.
set conceallevel=2 concealcursor=

"set colorcolumn=79

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
function! ResCur()
  if line("'\"") <= line("$")
    silent! normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" 

" Key-mappings: 
" nnoremap <expr> n  'Nn'[v:searchforward]
" nnoremap <expr> N  'nN'[v:searchforward]
" TODO
" Use <C-Space>.
" nmap <C-Space>  <C-@>
" cmap <C-Space>  <C-@>

" Visual mode keymappings:
" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv


" Insert mode keymappings:
" <C-t>: insert tab.
inoremap <C-t>  <C-v><TAB>
" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>
" TODO 根据window定制
"nnoremap <silent> <C-l>    :<C-u>redraw!<CR>
" TODO 删除
"nnoremap <silent><C-l>  :mod <bar> :call sy#util#refresh_windows()<cr>
nnoremap <silent><C-l>  :mod<cr>


" Alt key shortcuts not working on gnome terminal with Vim:
"   https://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
if !has('nvim') && &term[:4] == "xterm"
  " https://vim.wikia.com/wiki/VimTip738
  " NOTE: key 大小写敏感
  let alt_tab = [9, 8, 'h', 'j', 'k', 'l']
  " fix meta-keys which generate escape sequences
  for key in alt_tab
    " set key code, mapping delay >> key code delay
    " 以keycode的方式处理escape sequences, 比映射<esc>k更高效
    " 如果ttimeoutlen足够小, 用户几乎不可能通过手动生成<esc>key序列
    exec "set <M-".key.">=\e".key
    exec "imap \e".key." <M-".key.">"
  endfor
endif

" TODO ctrl shift组合键
" resize window
nnoremap <silent>       [WB]  :vertical resize +3<CR>
nnoremap <silent>       [WS]  :vertical resize -3<CR>
" cmdline, statusline, min_win_line(2), tabline
nnoremap <silent><expr> [HS]  winheight(0) <= (&lines-3-&cmdheight) ? ':resize -3<CR>' : ' '
nnoremap <silent>       [HB]  :resize +3<CR>

let s:platform = Platform()
if s:platform == 'alacritty' || s:platform == 'macvim'
  " Alacritty/MacVim workaround
  " <A-k>:˚  <A-j>:∆  <A-h>:˙  <A-l>:¬  <A-9>:ª  <A-8>:•
  map ˚ [HB]
  map ∆ [HS]
  map ˙ [WS]
  map ¬ [WB]
  nmap ª :call acm#compile()<CR>
  nmap <silent> • :<C-u>call <SID>rm_trailingSpace()<CR>
elseif s:platform == 'nvim-qt'
  " nvim-qt workaround
  map <A-˚> [HB]
  map <A-∆> [HS]
  map <A-˙> [WS]
  map <A-¬> [WB]
else
  map <A-k> [HB]
  map <A-j> [HS]
  map <A-h> [WS]
  map <A-l> [WB]
  nmap <A-9> :call acm#compile()<CR>
  imap <A-9> <ESC>:call acm#compile()<CR>
  nmap <silent> <A-8> :<C-u>call <SID>rm_trailingSpace()<CR>
end

" Command-line mode keymappings:
" <C-a>, A: move to head.
"cnoremap <C-a>          <Home>
" <C-b>: previous char.
"cnoremap <C-b>          <Left>
" <C-d>: delete char.
"cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
"cnoremap <C-e>          <End>
" <C-f>: next char.
"cnoremap <C-f>          <Right>
" <C-n>/<C-p>: next/previous history.
cnoremap <C-n>          <Down>
cnoremap <C-p>          <Up>
" <C-y>: paste.
"cnoremap <C-y>          <C-r>*
" <C-g>: Exit.
"cnoremap <C-g>          <C-c>

" [Space]: Other useful commands
" Smart space mapping.
nmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
map <F1> <Nop>
imap <F1> <Nop>

" Set autoread.
nnoremap [Space]ar
      \ :<C-u>call vimrc#toggle_option('autoread')<CR>
" Set spell check.
"nnoremap [Space]p
"      \ :<C-u>call vimrc#toggle_option('spell')<CR>
"      \: set spelllang=en_us<CR>
"      \: set spelllang+=cjk<CR>
" nnoremap [Space]w :<C-u>call vimrc#toggle_option('wrap')<CR>

" Easily edit .vimrc
"nnoremap <silent> [Space]ev  :<C-u>edit $MYVIMRC<CR>

" Useful save mappings.
nnoremap <silent> <Leader>w :<C-u>update<CR>

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap    [Window]   <Nop>
nmap    s [Window]
nnoremap <silent> [Window]p  :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
" nnoremap <silent> [Window]j  <c-w>j
" nnoremap <silent> [Window]k  <c-w>k
" nnoremap <silent> [Window]h  <c-w>h
" nnoremap <silent> [Window]l  <c-w>l
" FIXME CTRL-I or <Tab>, 映射了<Tab>, CTRL-I也无法使用
" nnoremap <silent> <Tab>  :wincmd w<CR>

" Disable Ex-mode.
nnoremap Q  q
function! s:q()
  let cur_winnr = winnr()
  let max_winnr = winnr('$')
  if v:count == 0
    if winnr('$') != 1
      call vimrc#windowjump(winnr())
      try
        exe cur_winnr.'close'
      catch /.*/
      endtry
    endif
  elseif max_winnr >= v:count  " 合法性检查
    exe v:count . "wincmd q"
  endif
endfunction
"winnr('$') != 1 ? ':<C-u>close<CR>' : ""
" ref to :h v:count
nnoremap <silent> q :<C-U>call <SID>q()<CR>
autocmd MyAutoCmd FileType fugitive nnoremap <buffer> <silent> q :<C-U>call <SID>q()<CR>

" e: Change basic commands
" The prefix key.
nnoremap [Alt]   <Nop>
nmap    S  [Alt]

" Indent paste.
nnoremap <silent> [Alt]p o<Esc>pm``[=`]``^
nnoremap <silent> [Alt]P O<Esc>Pm``[=`]``^

" Better x (delete into black hole register)
nnoremap x "_x

" Useless command.
nnoremap M  m

" Smart <C-f>, <C-b>.
noremap <expr> <C-f> max([winheight(0) - 2, 1])
      \ . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
      \ . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")

" Disable ZZ.
nnoremap ZZ  <Nop>

nnoremap <silent> cd :exe 'cd ' . expand('%:p:h') <bar> echo expand('%:p:h')<CR>

" Select rectangle.
xnoremap r <C-v>

" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" Substitute.
" xnoremap s :<C-u>%s//gc<Left><Left><Left>

" Sticky shift in English keyboard.
" Sticky key.
" inoremap <expr> ;  vimrc#sticky_func()
" cnoremap <expr> ;  vimrc#sticky_func()
" snoremap <expr> ;  vimrc#sticky_func()

" Easy escape. jj
" 减轻左小拇指的负担, 参考自《笨方法学Vimscript》的"锻炼你的手指"那一章. 可视模式可通过v键退出
inoremap jk <esc>
" 强迫自己学习新的mapping，但是针对Poker键盘Esc键很顺手
"inoremap <esc> <nop>

cnoremap <expr> j
      \ getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'

inoremap j<Space>     j

" a>, i], etc...
" <angle>
onoremap aa  a>
xnoremap aa  a>
onoremap ia  i>
xnoremap ia  i>

" [rectangle]
onoremap ar  a]
xnoremap ar  a]
onoremap ir  i]
xnoremap ir  i]

" Improved increment.
nmap <C-a> <SID>(increment)
nmap <C-x> <SID>(decrement)
nnoremap <silent> <SID>(increment)    :AddNumbers 1<CR>
nnoremap <silent> <SID>(decrement)   :AddNumbers -1<CR>
command! -range -nargs=1 AddNumbers
      \ call vimrc#add_numbers((<line2>-<line1>+1) * eval(<args>))

nnoremap <silent> #    <C-^>

" Change current word and repeatable
"nnoremap cn *``cgn
"nnoremap cN *``cgN

" Change selected word and repeatable
"vnoremap <expr> cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
"vnoremap <expr> cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" if exists(':tnoremap')
" TODO
" tnoremap   <ESC>      <C-\><C-n>
tnoremap   jk         <C-\><C-n>
" tnoremap   j<Space>   j
" tnoremap <expr> ;  vimrc#sticky_func()

function! s:open_default_shell() abort
  exe 'topleft split'
  let lines = &lines * 28 / 100
  if lines < winheight(0)
    exe 'resize ' . lines
  endif
  if g:Windows
    let shell = empty($SHELL) ? 'cmd.exe' : $SHELL
  else
    let shell = empty($SHELL) ? 'zsh' : $SHELL
  endif
  if has('nvim')
    exe 'terminal '.shell
    " setlocal nonumber norelativenumber
    " setlocal statusline=%{b:term_title}
  else
    call term_start(shell, {'curwin' : 1, 'term_finish' : 'close'})
  endif
  setlocal nobuflisted
  startinsert
endfunction
noremap <space>' :call <SID>open_default_shell()<CR>

" :Rename newname重命名文件
:command! -nargs=1 -complete=file Rename let tpname = expand('%:t') | saveas <args> | edit <args> | call delete(expand(tpname)) | silent exe 'bdelete! ' . fnameescape(tpname)
" 设定缩略名或者同义命令
" Todo: 困扰rename在不需要替换时被替换
" :cabbrev rename Rename

" 清除行尾空格, :h :s 查看'替换'帮助
func! s:rm_trailingSpace() abort
  let save_cursor = getcurpos()
  try
    %s/\s\+$//g
    ":noh<CR>
  catch /^Vim\%((\a\+)\)\=:E486/
    echo 'No Trailing Space'
  endtry

  call setpos('.', save_cursor)
endf

" 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

"------------------------------------------------------
" 插入date_time
"
" :h key-notation
" :h <C-R>
" :h <EOL>
" 回车(Carriage Return)
" 换行(Line Feed)
nnoremap tm "=strftime("%y年%m月%d日%a")<CR>P
inoremap <F5> <C-R>=strftime("%y年%m月%d日")<CR><Esc>

" Yank from the cursor to the end of the line, to be consistent with C and D.
" :h Y
nnoremap Y y$

" from spacevim
for i in range(1, 9)
  " The <C-U> is used to remove the range that Vim may insert.
  exe printf('nnoremap <silent> [Space]%d :<C-U>call vimrc#windowjump(%d)<CR>', i, i)
endfor

" 

" TODO: syntax highlighting breaks for big file after jump or search #2790, https://github.com/vim/vim/issues/2790
