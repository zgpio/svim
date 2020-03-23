"---------------------------------------------------------------------------
" Initialize:
"

let g:Windows = has('win64')
let g:Unix = has('unix')
let g:Linux = has('unix') && !has('macunix') && !has('win32unix')
let g:OSX = has('macunix')
lockvar g:Windows
lockvar g:Unix
function Platform() abort
  if exists('$ALACRITTY_LOG')
    return 'alacritty'
  elseif exists('$KITTY_WINDOW_ID')
    return 'kitty'
  elseif $TERM_PROGRAM == 'Apple_Terminal'
    return 'apple'
  elseif exists(':GuiFont')
    " TODO nvim_gui_shim.vim 需要提前加载
    return 'nvim-qt'
  elseif has("gui_macvim")
    return 'macvim'
  else
    return 'unknown'
  end
endfunction

" NOTE: Windows修改注册表设置cmd使用utf-8(65001), 而且,
" 不久之后cmd将默认使用utf-8
if &encoding !=# 'utf-8'
  set encoding=utf-8
endif

" Build encodings.
set fileencodings=ucs-bom,utf-8,gbk,utf-16le,cp1252,iso-8859-15

" Setting of terminal encoding.
if !has('gui_running') && g:Windows
  " set termencoding=cp936
endif

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

" Use English message.
language message C
" https://github.com/neovim/neovim/issues/5683
lang en_US.UTF-8

" Use ',' instead of '\'.
" Use <Leader> in global plugin.
let g:mapleader = ' '
"let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap ;  <Nop>
nnoremap m  <Nop>
nnoremap ,  <Nop>

if g:Windows
  " Exchange path separator.
  set shellslash
endif

let $CACHE = expand('~/.cache')
if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif
" Load dein.
" FIXME finddir('dein.vim', '.;')  一直返回空
" let s:dein_dir = finddir('dein.vim', expand('~/.cache/nvim/').'**')
if &runtimepath !~ '/dein.vim'
  let s:dein_dir = expand('$CACHE/dein/repos/gitee.com/zgpio/dein.vim')
  if !isdirectory(s:dein_dir)
    execute '!git clone https://gitee.com/zgpio/dein.vim' s:dein_dir
  endif
  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

" Disable packpath
set packpath=

" Disable menu.vim
if has('gui_running')
   set guioptions=Mc
endif

"---------------------------------------------------------------------------
" Disable standard Vim plugins
" ref to $VIM/vim{version}/plugin

let g:loaded_getscriptPlugin  = 1
let g:loaded_gzip             = 1
let g:loaded_logiPat          = 1
" manpager.vim can not be disabled
let g:loaded_matchparen       = 1
let g:loaded_netrwPlugin      = 1
let g:loaded_rrhelper         = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin        = 1
let g:loaded_2html_plugin     = 1
let g:loaded_vimballPlugin    = 1
"let g:loaded_zipPlugin        = 1
