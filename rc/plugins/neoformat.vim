:py3 << EOF
import vim

style = ('{'
         'AccessModifierOffset: -4,'
         'AllowShortIfStatementsOnASingleLine: true,'
         'AlwaysBreakTemplateDeclarations: true,'
         'AllowShortFunctionsOnASingleLine: false,'
         'BreakBeforeBraces: Stroustrup,'
         'IndentWidth: 4,'
         'Standard: C++11,'
         '}')
style = f'-style="{style}"'
vim.command(f"let clang_style='{style}'")

EOF
" replace the file, instead of updating buffer (default: 0),
" send data to stdin of formatter (default: 0)
let g:neoformat_cpp_clang_format = {
        \ 'exe': 'clang-format',
        \ 'args': [clang_style, ],
        \ 'stdin': 1,
        \ }

let g:neoformat_enabled_cpp = ['clang_format']
