let s:ET = {'is_open': v:false}

" 不依赖 g:is_* 全局变量, 直接用 has() 判断平台
let s:is_win = has('win32') || has('win64')
let s:is_nvim = has('nvim')

function! s:Shell() abort
  "{{{
  if s:is_win
    " cmd 兼容性最好 (&&, &)
    return !empty($COMSPEC) ? $COMSPEC : 'cmd'
  endif
  " macOS 默认 zsh, Linux 多为 bash, 统一尊重用户的 $SHELL
  if !empty($SHELL) && executable($SHELL)
    return $SHELL
  endif
  for l:sh in ['/bin/zsh', '/bin/bash', '/bin/sh']
    if executable(l:sh)
      return l:sh
    endif
  endfor
  return &shell
  "}}}
endfunction

" 把多条命令连成一行: cmd 用 &, 其余 shell 用 ;
function! easy_term#Join(cmds) abort
  "{{{
  return join(a:cmds, s:is_win ? ' & ' : '; ')
  "}}}
endfunction

" 命令行参数转义, 只在需要时才加引号(分支/tag 名通常不需要)
function! easy_term#Escape(arg) abort
  "{{{
  if a:arg =~# '^[A-Za-z0-9._/@+=:-]\+$'
    return a:arg
  endif
  if s:is_win
    return '"' . substitute(a:arg, '"', '\\"', 'g') . '"'
  endif
  return "'" . substitute(a:arg, "'", "'\\\\''", 'g') . "'"
  "}}}
endfunction

" opts: {'cwd': '/path'}  可选, 指定终端工作目录
function! s:ET._new_terminal(...) abort
  "{{{
  let l:opts = a:0 > 0 ? a:1 : {}
  if !s:is_nvim && !has('terminal')
    echoerr 'This Vim was built without +terminal.'
    return self
  endif
  if mode() == 'i'
    call feedkeys("\<ESC>", 'i')
  endif

  let l:term_opts = {}
  if get(l:opts, 'cwd', '') != ''
    let l:term_opts['cwd'] = l:opts['cwd']
  endif

  if !s:is_nvim
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
  if !s:is_nvim
    call job_stop(self['job_id'])
  else
    call jobstop(self['job_id'])
  endif
  let self['is_open'] = 0
  "}}}
endfunction

function! s:ET._feedkey(key) abort
  "{{{
  if !s:is_nvim
    call term_sendkeys(self['term_obj'], a:key)
  else
    call chansend(self['job_id'], substitute(a:key, "\<CR>", "\r", 'g'))
  endif
  "}}}
endfunction

" shell 是否已经打印出 prompt
function! s:Ready(obj) abort
  "{{{
  let l:buf = a:obj['term_obj']
  if !bufexists(l:buf)
    return -1
  endif
  if !s:is_nvim
    let l:row = term_getcursor(l:buf)[0]
    return term_getline(l:buf, l:row) !=# ''
  endif
  return len(filter(getbufline(l:buf, 1, '$'), 'v:val !=# ""')) > 0
  "}}}
endfunction

function! s:Poll(obj, text, tries, timer) abort
  "{{{
  let l:ready = s:Ready(a:obj)
  if l:ready < 0
    return
  endif
  " 最多等 3 秒
  if !l:ready && a:tries < 60
    call timer_start(50, function('s:Poll', [a:obj, a:text, a:tries + 1]))
    return
  endif
  call a:obj._feedkey(a:text)
  "}}}
endfunction

" 发送一条命令; execute 为真时自动回车, 否则只预填
" 会等 shell 打印出 prompt 后再发送, 否则 zsh 会多显示一行(行尾出现 %)
function! s:ET._run(cmd, execute) abort
  "{{{
  let l:text = a:cmd . (a:execute ? "\<CR>" : '')
  call timer_start(50, function('s:Poll', [self, l:text, 0]))
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
