let s:ET = {'is_open': v:false}

function! s:ET._new_terminal() abort
  if mode() == 'i'
    call feedkeys("\<ESC>", 'i')
  endif

  let l:bash = '/bin/bash'
  if g:is_windows
    let l:bash = 'cmd'
  endif

  if g:is_macvim
    let l:bash = '/bin/zsh'
  endif

  let self['term_obj'] = term_start(l:bash)
  let self['job_id'] = term_getjob(self['term_obj'])
  let self['is_open'] = 1
endfunction

function! s:ET._close() abort
  call job_stop(self['job_id'])
  let self['is_open'] = 0
endfunction

function! s:ET._feedkey(key) abort
  call term_sendkeys(self['term_obj'], a:key)
endfunction

function! easy_term#NewEasyTermial() abort
  return deepcopy(s:ET)
endfunction
