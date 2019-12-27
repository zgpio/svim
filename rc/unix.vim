" http://fcitx.github.io/handbook/chapter-remote.html
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx-remote -o")
      let g:input_toggle = 0
   endif
endfunction

if executable('fcitx-remote')
  "set timeoutlen=150
  autocmd InsertLeave * call Fcitx2en()
  "autocmd InsertEnter * call Fcitx2zh()
endif

" Use sh. It is faster
set shell=sh

" Set path.
let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH

if has('gui_running')
  finish
endif

"---------------------------------------------------------------------------
" For TUI:
"

if has('nvim')
  " nvim terminal colors setting ref to onedark.vim

  " TODO: remove
  " let s:num = 0
  " for s:color in g:terminal_ansi_colors
  "   let g:terminal_color_{s:num} = s:color
  "   let s:num += 1
  " endfor
  " unlet! s:num
  " unlet! s:color
else
  " Enable 256 color terminal.
  set t_Co=256

  " set term=xterm-256color

  " let &t_ti .= "\e[?2004h"
  " let &t_te .= "\e[?2004l"
  " let &pastetoggle = "\e[201~"

  " function! s:XTermPasteBegin(ret) abort
  "   setlocal paste
  "   return a:ret
  " endfunction

  " noremap <special> <expr> <Esc>[200~ s:XTermPasteBegin('0i')
  " inoremap <special> <expr> <Esc>[200~ s:XTermPasteBegin('')
  " cnoremap <special> <Esc>[200~ <nop>
  " cnoremap <special> <Esc>[201~ <nop>

  " Optimize vertical split.
  " Note: Newest terminal is needed.
  " let &t_ti .= "\e[?6;69h"
  " let &t_te .= "\e7\e[?6;69l\e8"
  " let &t_CV = "\e[%i%p1%d;%p2%ds"
  " let &t_CS = "y"

  " Change cursor shape.
  " http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
  " TODO 在Konsole中无法使用
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[0 q"
endif

" Enable true color
if exists('+termguicolors')
  " NOTE: mac terminal 不支持24位色
  " set termguicolors
endif
