function! GetCurrentBufferPath() abort
  return tr(expand('%:p'), '\', '/')
endfunction

function! GetProjectCWD() abort
  return tr(getcwd(), '\', '/')
endfunction

function! GetCurrentBufferDir() abort
  return tr(expand('%:p:h'), '\', '/')
endfunction

function! GetCurrentBufferDir() abort
  return tr(expand('%:p:h'), '\', '/')
endfunction

function! s:Exit_cb(job, status) abort
  if !exists("s:temp_name")
    return
  endif
  call delete(s:temp_name)
endfunction

function! TermStart(cmd, cwd) abort
  "{{{
  let l:options = {}
  if a:cwd != ''
    let l:options['cwd'] = a:cwd
  endif
  if g:is_vim
    let l:options['exit_cb'] = function('s:Exit_cb')
    call term_start(a:cmd, l:options)
  else
    split new
    call termopen(a:cmd, l:options)
  endif
  "}}}
endfunction

function! RunCMD(cmd, cwd) abort
  "{{{
  let s:temp_name = tempname()
  let s:temp_name .= '.bat'
  call writefile(a:cmd, s:temp_name)
  call TermStart(s:temp_name, a:cwd)
  "}}}
endfunction

function! NewTerm() abort
  "{{{
  if g:is_windows
    let l:res =  term_start('cmd')
  elseif g:is_macvim
    let l:res =  term_start('/bin/zsh')
  else
    let l:res =  term_start('/bin/bash')
  endif
  return l:res
  "}}}
endfunction

function! RunMakeInTerminal()
  " 启动终端并获取 buffer
  let buf = NewTerm()
  call term_sendkeys(buf, 'make' . "\<CR>")
endfunction

func s:GotoLine2(timer) abort
  let l:int = str2nr(input('Line: '))
  call cursor(l:int, 0)
  redraw!
endfunc

function! GotoLine() abort
  "{{{
  let timer = timer_start(1, function('s:GotoLine2'))
  "}}}
endfunction

