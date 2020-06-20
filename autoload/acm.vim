" < C/C++ Compile, Link, and Run, for Acm >
" ref to Svtter/ACM.vim
" c-support, ref to vim-scripts/c.vim

" %<.o
" exe ':bo cope'
" exe ':bo cw'
" let v:statusmsg = ''
" empty(v:statusmsg)
" exe 'let &l:makeprg="' . s:windows_CPPFlags.Exe . '"'

let s:gen_ext = g:Windows ? '.exe':''

function! s:OnEvent(job_id, data, event) dict
  if a:event == 'exit'
    silent Neomake!
  endif

  " call append(line('$'), str)
endfunction
let s:callbacks = {
      \ 'on_exit': function('s:OnEvent')
      \ }

" TODO 路径依赖
let $OJ = expand('~/OJ')
let $OJ_BUILD = expand('~/OJ/build')
func! acm#compile()
  let Src = expand("%:p")
  let ext = expand("%:e")
  let Exe = expand("%:p:t:r").s:gen_ext
  if ext == "c" || ext == "cpp" || ext == "cxx" || ext == "cc"
    " let save = &makeprg
    exe ":ccl"
    exe ":update"
    " On Windows, rename `mingw32-make.exe` to `make.exe`
    " let &l:makeprg = 'make -C ' . expand("%:p:h") . ' OBJS=' . Exe
    let &l:makeprg = 'make -C ' . $OJ_BUILD
    let str = printf('cmake -S %s -B %s -DMAIN:STRING=%s ..', $OJ, $OJ_BUILD, Src)
    let job1 = jobstart(['bash', '-c', str], extend({'shell': 'shell1'}, s:callbacks))
    " let &l:makeprg = save
  elseif ext == "py"
    if has('nvim')
      exe 'split'
    endif
    let cmd = printf('terminal python3 "%s"', Src)
    exe cmd
  else
    echohl WarningMsg | echo " Incorrect source file"
  endif
endfunc

function! AcmJobFinished() abort
  let context = g:neomake_hook_context
  "echom string(context.jobinfo)
  if context.jobinfo.exit_code == 0 && context.jobinfo.maker.args!=[] && context.jobinfo.maker.args[1] =~ 'build'
    " let EXE = expand("%:p:h").'/exes/'.expand("%:p:t:r").s:gen_ext
    let EXE = $OJ_BUILD . '/' . expand("%:p:t:r")
    let SRC = expand("%:p:h")
    if has('nvim')
      exe 'split'
    endif
    exe 'lcd' SRC
    exe 'terminal' EXE
    setlocal nonumber norelativenumber
    " setlocal statusline=%{b:term_title}
    echom EXE
  else
    echom printf('The job for maker %s exited non-zero: %s',
    \ context.jobinfo.maker.name, context.jobinfo.exit_code)
    call luaeval('print(vim.inspect(_A))', context.jobinfo)
  endif
endfunction
autocmd MyAutoCmd User NeomakeJobFinished call AcmJobFinished()
