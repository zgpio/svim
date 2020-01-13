" file/rec cause FileNotFoundError when ag/rg is not available
if executable('rg')
  " https://blog.burntsushi.net/ripgrep/
  " ripgrep
  " TODO:
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git !tags'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
else
  call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

  " Ag(银) command on grep source
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--ignore=tags', '--smart-case'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

call denite#custom#source('file/old', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
call denite#custom#source('file/old', 'converters', ['converter/relative_word'])
call denite#custom#source('tag', 'matchers', ['matcher/substring'])

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])


" Note: Can't close denite window immediately
" ~/.config/nvim/init.vim
" Add custom menus
let s:menus = {}
let s:menus.vimrc = {
      \ 'description': 'Vim config',
      \ }
" TODO: add defx open .vim
let s:menus.vimrc.file_candidates = [
      \ ['    > Edit onfiguration file (vimrc)', '~/.vim/vimrc'],
      \ ['    > Edit onfiguration file (deinft.toml)', '~/.vim/rc/deinft.toml'],
      \ ]

let s:menus.my_commands = {
      \ 'description': 'Example commands'
      \ }
let s:menus.my_commands.command_candidates = [
      \ ['Split the window', 'vnew'],
      \ ['Open zsh menu', 'Denite menu:zsh'],
      \ ]
call denite#custom#var('menu', 'menus', s:menus)


call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/', 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

" Note: lambda function is not supported in Vim8.
" call denite#custom#action('file', 'test', {context -> execute('let g:foo = 1')})
"
" call denite#custom#action('file', 'test2',
"      \ {context -> denite#do_action(context, 'open', context['targets'])})

function! s:dein_update(context)
  " Note: echo消息会被清空
  "echom string(a:context)
  let word = a:context['targets'][0]['word']
  if word =~ 'gitee.com'
    let plugin = split(word, '/')[2]
  else
    let plugin = split(word, '/')[1]
  endif
  call dein#update(plugin)
endfunction
function! s:dein_open(context)
  " Note: echo消息会被清空
  let dir = a:context['targets'][0]['action__path']
  execute('Defx -split=vertical -columns=mark:indent:git:icons:filename:type -direction=topleft -winwidth=40 -listed -buffer-name=tab`tabpagenr()` '.dir)
  " echom string(dir)
endfunction
" dein.vim/rplugin/python3/denite/source/dein.py 中指明了kind为directory
call denite#custom#action('directory', 'dein_update', function('s:dein_update'))
call denite#custom#action('directory', 'dein_open', function('s:dein_open'))
"call denite#custom#map('normal', 'U', '<denite:do_action:dein_update>', 'noremap')
"call denite#custom#map('normal', 'O', '<denite:do_action:dein_open>', 'noremap')

" Note: `true` in denite doc; has('patch-7.4.1154')
" v:true/v:false, rather than 1/0
" denite-option-statusline, disable denite statusline.
" :h denite#custom#option()
" call denite#custom#option('default', {
"      \ 'winheight': 15,
"      \ 'highlight_matched_char': 'MoreMsg',
"      \ 'highlight_matched_range': 'MoreMsg',
"      \ 'direction': 'rightbelow',
"      \ 'statusline': v:false,
"      \ 'prompt': '>',
"      \ 'source_names': 'short',
"      \ 'split': 'floating',
"      \ })
call denite#custom#option('default', {
      \ 'highlight_filter_background': 'CursorLine',
      \ 'source_names': 'short',
      \ 'split': 'floating',
      \ })

call denite#custom#option('_', {
  \ 'statusline': v:false,
  \ 'smartcase': v:true,
  \ 'prompt': ''
  \ })
" ➭
