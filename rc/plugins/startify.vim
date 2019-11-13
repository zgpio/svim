" :h v:val
"function! StartifyEntryFormat()
"    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
"endfunction
let g:startify_custom_header_quotes = [
      \ ["调试比编写代码困难一倍, 因此, 如果你尽可能巧妙地编写代码, 则根据定义, 你不够聪明来进行调试.", '', '- Brian Kernighan'],
      \ ["如果你没有完成, 那么你只是忙, 而没有生产力."],
      \ ['改写旧程序以适应新机器通常意味着使新机器的行为与旧机器相似.', '', '- Alan Perlis'],
      \ ['傻瓜忽视复杂性. 实用主义者忍受它. 有些人可以避免它. 天才消除它.', '', '- Alan Perlis'],
      \ ['改变规范以适应程序比反过来更容易.', '', '- Alan Perlis'],
      \ ['早期崩溃. ', '', '一个死亡程序通常比一个瘫痪的程序损害少很多.'],
      \ ['尽量减少模块之间的耦合. ', '', '通过编写“害羞”的代码并应用Demeter法(最少知识原则)来避免耦合.'],
      \ ['设计测试.', '', '在写代码之前就开始考虑测试.'],
      \ ['与用户一起思考, 像用户一样.', '', '这是深入了解系统如何真正被使用的最好方式.'],
      \ ['使用项目词汇表', '', '为项目创建和维护所有特定术语和词汇的单一来源.'],
      \ ["当你准备好时开始.", '', "You've been building experience all your life. Don't ignore niggling doubts."],
      \ ["不要成为优等方法的奴隶.", '', "不要盲目采用任何技术, 而不能将其放入开发实践和功能的背景中."],
      \ ['围绕功能组织团队.', '', "不要将设计人员与编码人员, 测试人员与数据建模人员分开. 按照构建代码的方式构建团队."],
      \ ['尽早测试. 经常测试. 自动测试.', '', 'Tests that run with every build are much more effective than test plans that sit on a shelf.'],
      \ ['一旦人类测试人员发现一个bug, 这应该是最后一次发现该bug. 自动测试应该从此开始检查.'],
      \ ['签署你的工作.', '', '年轻的工匠们很自豪地签署他们的工作. 你应该也是.'],
      \
      \ ['42. 使用:find打开文件'],
      \ ['26. 在长短不一的高亮块后添加文本'],
      \ ['29. 使用:t和:m命令复制和移动行'],
      \ ]

" `set ambiwidth=double` 使box显示出现问题, 在startify doc中说明了
" 设置box边框, 或使用 call startify#fortune#cowsay('', '─','│','┌','┐','┘','└')
let g:startify_fortune_use_unicode = 1
" 右移3个空格, 注意单引号不能嵌套, 或使用 "\"   \" . v:val"
let g:startify_custom_header = map(startify#fortune#boxed(), '"   " . v:val')
