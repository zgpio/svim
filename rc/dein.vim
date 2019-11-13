"let g:dein#install_log_filename = '~/dein.log'

let s:base = expand('$CACHE/dein')
let g:dein#auto_recache = 1
if !dein#load_state(s:base)
  finish
endif

call dein#begin(s:base, expand('<sfile>'))

call dein#load_toml('$root/rc/dein.toml', {'lazy': 0})
call dein#load_toml('$root/rc/deinlazy.toml', {'lazy': 1})
call dein#load_toml('$root/rc/deinft.toml')

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  call dein#install()
endif
