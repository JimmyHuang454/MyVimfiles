" Author: Jimmy Huang (1902161621@qq.com)
" LICENSE: WTFPL
" DATES: 2020-03-10

if exists('g:loaded_myvimrc_main')
  finish
endif
let g:loaded_myvimrc_main = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Start                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:my_vimrc_file_dir = expand( '<sfile>:p:h' )

function! main#Start()
    "{{{
    let g:has_terminal = has('terminal')
    let g:has_python3  = get(g:, 'use_python3', has('python3'))
    let g:is_windows   = has('win32')
    let g:is_macvim    = has('gui_macvim')
    let g:is_neovim    = has('nvim')
    let g:has_git      = executable('git')
    let g:has_job      = (!g:is_neovim && has('job') && has('channel') ) || (g:is_neovim && has('nvim-0.2.0'))
    let g:is_gui       = has('gui')

  try
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
  catch 
    call g:LoadFile('mswindows/mswin.vim', 0)
    call g:LoadFile('mswindows/vimrc_example.vim', 0)
  endtry
  " if g:is_windows && !g:is_neovim
  "   source $VIMRUNTIME/vimrc_example.vim
  "   source $VIMRUNTIME/mswin.vim
  "   behave mswin
  " else
  "   call g:LoadFile('mswindows/mswin.vim', 0)
  "   call g:LoadFile('mswindows/vimrc_example.vim', 0)
  " endif


  call g:LoadFile('terminal_alt.vim', 0)
  call g:LoadFile('ornament.vim', 0)
  call g:LoadFile('mapping.vim', 0)

  call g:LoadFile('plugin_opts.vim', 0)
  if get(g:, 'use_basic_plugin', v:true)
    call g:LoadFile('basic_plugin.vim', 0)
  endif
  if get(g:, 'use_basic_plugin', v:true)
    call g:LoadFile('heavy_plugin.vim', 0)
  endif
  if exists('g:pre_loaded_plugin')
    for item in g:pre_loaded_plugin
      call g:LoadFile(item, 0)
    endfor
  endif
  call g:LoadFile('optional_plugin.vim', 0)
  call g:LoadFile('autocmd.vim', 0)
  call g:LoadFile('cwd_snippets.vim', 0)
  call g:LoadFile('utils.vim', 0)
  "}}}
endfunction

call main#Start()
