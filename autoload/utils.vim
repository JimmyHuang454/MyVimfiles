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

" fugitive 状态页按 dd/dv/dh/ds 之前记录窗口布局, SmartQuit 时还原
function! DiffSnapshot() abort
  "{{{
  let t:diff_layout = {
        \ 'wins': map(range(1, winnr('$')), 'win_getid(v:val)'),
        \ 'origin': win_getid(),
        \ 'bufs': map(range(1, winnr('$')), '[win_getid(v:val), winbufnr(v:val)]'),
        \ }
  "}}}
endfunction

" 不重写 fugitive 的映射(各版本实现不同), 只在原映射前面加上记录布局
function! s:WrapFugitiveDiffMaps() abort
  "{{{
  for l:key in ['dd', 'dv', 'dh', 'ds']
    let l:m = maparg(l:key, 'n', 0, 1)
    if empty(l:m) || !get(l:m, 'buffer', 0) || l:m.rhs =~# 'DiffSnapshot'
      continue
    endif
    let l:m.rhs = substitute(l:m.rhs, '^:<C-U>', ':<C-U>call DiffSnapshot()<Bar>', '')
    call mapset('n', 0, l:m)
  endfor
  "}}}
endfunction

augroup FugitiveDiffLayout
  autocmd!
  autocmd User FugitiveIndex call s:WrapFugitiveDiffMaps()
augroup END

" q: 普通窗口直接 :q; 在 diff 模式下退出对比:
"   - 从 fugitive 状态页用 dd/dv/dh/ds 打开的: 关闭 dd 新开的所有窗口, 回到状态页(dd 之前的布局)
"   - 其它(:Gdiffsplit 等): 关闭所有对比窗口, 只保留工作区文件(非 fugitive:// 的窗口)
function! SmartQuit() abort
  "{{{
  if !&diff
    quit
    return
  endif

  if exists('t:diff_layout')
    let l:layout = t:diff_layout
    unlet t:diff_layout
    let l:diff_wins = filter(range(1, winnr('$')), 'getwinvar(v:val, "&diff")')
    for l:nr in reverse(copy(l:diff_wins))
      if index(l:layout.wins, win_getid(l:nr)) < 0
        execute l:nr . 'close'
      endif
    endfor
    diffoff!
    " dd 可能把原有窗口里的 buffer 换成了工作区文件, 换回去
    for [l:id, l:buf] in l:layout.bufs
      let l:nr = win_id2win(l:id)
      if l:nr > 0 && winbufnr(l:nr) != l:buf && bufexists(l:buf) && bufname(l:buf) !=# ''
        call win_execute(l:id, 'silent! buffer ' . l:buf)
      endif
    endfor
    call win_gotoid(l:layout.origin)
    return
  endif
  let l:diff_wins = filter(range(1, winnr('$')), 'getwinvar(v:val, "&diff")')
  if len(l:diff_wins) < 2
    diffoff!
    return
  endif

  let l:keep = winnr()
  for l:nr in l:diff_wins
    if bufname(winbufnr(l:nr)) !~# '^fugitive://'
      let l:keep = l:nr
      break
    endif
  endfor

  for l:nr in reverse(copy(l:diff_wins))
    if l:nr != l:keep
      execute l:nr . 'close'
      if l:nr < l:keep
        let l:keep -= 1
      endif
    endif
  endfor
  execute l:keep . 'wincmd w'
  diffoff!
  "}}}
endfunction
