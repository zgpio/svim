let g:ycm_python_binary_path = 'python'
" 打开vim时不再询问是否加载ycm_extra_conf.py配置
let g:ycm_confirm_extra_conf = 0
" TODO 语法关键字补全
let g:ycm_seed_identifiers_with_syntax = 1
function! s:CustomizeYcmQuickFixWindow()
    " Move the window to the top of the screen.
    wincmd K
    " Set the window height to 5.
    5wincmd _
endfunction
autocmd User YcmQuickFixOpened call s:CustomizeYcmQuickFixWindow()


" let g:ycm_global_ycm_extra_conf='.../YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"set completeopt=longest,menu
" 在注释中开启补全
"let g:ycm_complete_in_comments = 1
"let g:ycm_collect_identifiers_from_comments_and_strings = 0
" 字符串中开启补全
"let g:ycm_complete_in_strings = 1
"let g:ycm_collect_identifiers_from_tags_files = 1
" 开启基于tag的补全，可以在这之后添加需要的标签路径
"let g:ycm_collect_identifiers_from_tags_files = 1
" 开始补全的字符数
"let g:ycm_min_num_of_chars_for_completion = 2
" 补全后自动关闭预览窗口
"let g:ycm_autoclose_preview_window_after_completion = 1
" 禁止缓存匹配项,每次都重新生成匹配项
"let g:ycm_cache_omnifunc=0
" 离开插入模式后自动关闭预览窗口
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" 整合UltiSnips的提示
"let g:ycm_use_ultisnips_completer = 1
" 在实现和声明之间跳转,并分屏打开
"let g:ycm_goto_buffer_command = 'horizontal-split'

"let g:ycm_show_diagnostics_ui = 0
let g:ycm_error_symbol = ''
let g:ycm_warning_symbol = ''
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 0
"let g:ycm_echo_current_diagnostic = 0
" NOTE: ref to syntax/README.txt
highlight SyntasticWarningSign guifg=#d19a66

" :h youcompleteme-goto-commands
"nnoremap <Leader>g :YcmCompleter GoTo<CR>
" GoToDefinitionElseDeclaration 子命令在文档中未提及
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
"nmap<C-a> :YcmCompleter FixIt<CR>
