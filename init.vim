" profile start profile.txt
" profile file ~/.vim/rc/*
" profile func dein#*

if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *?
        \ call vimrc#on_filetype()
  "autocmd CursorHold *.toml syntax sync minlines=300
  if has('nvim')
    autocmd TermOpen * startinsert
    autocmd TermOpen * set nonumber norelativenumber
  endif
  autocmd VimEnter,WinLeave * let g:pre_winid = win_getid()

  " autocmd BufEnter,WinEnter,InsertLeave * setl cursorline
  " autocmd BufLeave,WinLeave,InsertEnter * setl nocursorline
augroup END

let $root = fnamemodify(expand('<sfile>'), ':h')
" echom $root

" let g:python3_host_prog = '/home/zgp/anaconda3/bin/python'
if has('vim_starting')
  source $root/rc/base.vim
endif

source $root/rc/dein.vim

if has('vim_starting') && !empty(argv())
  call vimrc#on_filetype()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
endif

source $root/rc/misc.vim
if filereadable($root . '/rc/private.vim')
  source $root/rc/private.vim
endif

if g:Unix
  source $root/rc/unix.vim
endif

if !has('nvim') && has('gui_running')
  source $root/rc/gui.vim
endif

set secure

" vim: foldmethod=marker
