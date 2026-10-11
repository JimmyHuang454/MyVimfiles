let s:ET = {'is_open': v:false}

function! s:Shell() abort
  "{{{
  if g:is_windows
    return 'cmd'
  elseif g:is_macvim
    return '/bin/zsh'
  endif
  return '/bin/bash'
  "}}}
endfunction

" opts: {'cwd': '/path'}  可选, 指定终端工作目录
function! s:ET._new_terminal(...) abort
  "{{{
  let l:opts = a:0 > 0 ? a:1 : {}
  if mode() == 'i'
    call feedkeys("\<ESC>", 'i')
  endif

  let l:term_opts = {}
  if get(l:opts, 'cwd', '') != ''
    let l:term_opts['cwd'] = l:opts['cwd']
  endif

  if g:is_vim
    let self['term_obj'] = term_start(s:Shell(), l:term_opts)
    let self['job_id'] = term_getjob(self['term_obj'])
  else
    split new
    let self['term_obj'] = bufnr('%')
    let self['job_id'] = termopen(s:Shell(), l:term_opts)
  endif
  let self['is_open'] = 1
  return self
  "}}}
endfunction

function! s:ET._close() abort
  "{{{
  if !self['is_open']
    return
  endif
  if g:is_vim
    call job_stop(self['job_id'])
  else
    call jobstop(self['job_id'])
  endif
  let self['is_open'] = 0
  "}}}
endfunction

function! s:ET._feedkey(key) abort
  "{{{
  if g:is_vim
    call term_sendkeys(self['term_obj'], a:key)
  else
    call chansend(self['job_id'], substitute(a:key, "\<CR>", "\r", 'g'))
  endif
  "}}}
endfunction

" 发送一条命令; execute 为真时自动回车, 否则只预填
function! s:ET._run(cmd, execute) abort
  "{{{
  call self._feedkey(a:cmd . (a:execute ? "\<CR>" : ''))
  "}}}
endfunction

" 新开终端并发送命令的快捷封装
function! easy_term#Run(cmd, cwd, execute) abort
  "{{{
  let l:obj = easy_term#NewEasyTermial()
  call l:obj._new_terminal({'cwd': a:cwd})
  call l:obj._run(a:cmd, a:execute)
  return l:obj
  "}}}
endfunction

function! easy_term#NewEasyTermial() abort
  return deepcopy(s:ET)
endfunction
