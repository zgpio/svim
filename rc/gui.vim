"set ambiwidth=double  " ®
if g:Windows
  "guifontwide选项
  "(1) :set guifont=*
  "(2) :redir >> %
  "(3) :set guifont
  "(4) :redir end
  set guifont=SauceCodePro_NF:h12:cANSI:qDRAFT

  " Number of pixel lines inserted between characters.
  set linespace=2

  " Use DirectWrite
  "set renderoptions=type:directx

  if has('vim_starting')
    " 设置gvim窗口初始位置及大小
    winpos 660 120             "指定窗口左上角坐标，坐标系原点在屏幕左上角
    set lines=100 columns=100    "指定窗口大小，lines为高度，columns为宽度
  endif
else
  if has('gui_macvim')
    set guifont=SauceCodeProNerdFontCompleteM-Regular:h18
  else
    set guifont=SourceCodePro\ Nerd\ Font\ Mono\ 12
  endif
  if &columns < 170
    set columns=170  "Width of window.
  endif
  if &lines < 40
    set lines=40  "Height of window.
  endif
endif

"---------------------------------------------------------------------------
set mouse=nv
set mousemodel=

" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

" Hide toolbar and menus.
set guioptions-=Tt
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
" Not guitablabel.
set guioptions-=e
" Confirm without window.
set guioptions+=c
"set guioptions+=!

" Don't flick cursor.
set guicursor&
set guicursor+=a:blinkon0
