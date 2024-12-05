function! DartRunTest() abort
  let l:path = GetCurrentBufferPath()
  let l:cwd = GetProjectCWD()

  " call ECY#utils#TermStart('dart test ' . l:path, {'cwd': l:cwd})
  call ECY#utils#TermStart('dart -h',{})
endfunction

function! s:Init() abort
  if &ft != 'dart'
    return
  endif

  nmap <buffer> <C-t> :call DartRunTest()<CR>
endfunction

call s:Init()
