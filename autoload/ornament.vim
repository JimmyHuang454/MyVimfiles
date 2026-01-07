"""""""""""""""""""""""
"  decorate vim's UI  "
"""""""""""""""""""""""

"  设置字体 
if has('gui')
  set guifont=JetBrains\ Mono\:h14
endif

if g:is_windows && g:is_gui
  autocmd GUIEnter * simalt ~x
  set renderoptions=type:directx,renmode:0,taamode:1
endif

"  设置主题的类型
set background=dark

" 设置map识别失效时间
" set ttimeoutlen=50

" 内部工作编码
set encoding=utf-8

" 文件默认编码
set fileencoding=utf-8

" 打开文件时自动尝试下面顺序的编码
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1

if has('autocmd')
  " 打开 indent
	filetype plugin indent on
endif

if has('syntax')  
  " 使用代码高亮
	syntax enable 
	syntax on 
endif

" 显示匹配的括号
set showmatch

" 显示括号匹配的时间
set matchtime=2

" 显示最后一行
set display=lastline

" 允许下方显示目录
set wildmenu

" 文件换行符，默认使用 unix 换行符
set ffs=unix,dos,mac

"  显示n搜索结果，8.0后才有
set shortmess-=S

" 设置折叠
set fo+=mB
set fdm=marker

" 显示行号
set nu
set cul "?

" 高亮*的结果
set hlsearch

" 在最底下显示 命令行
set laststatus=2

" 关掉 gui那些烦人的弹出菜单
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=T

" 设置折叠
set wrap

set belloff=all

" 设置tab为 2 个空格
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

"设置80列竖线
set colorcolumn=81

set viminfo^='2000

if g:is_neovim
  au VimEnter * GuiPopupmenu 0
  au VimEnter * GuiTabline 0
endif
