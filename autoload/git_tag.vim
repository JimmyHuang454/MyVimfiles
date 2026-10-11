" 快速 bump git tag: 读取最新 tag, 末尾数字 +1, 打开 terminal 预填提交命令
" :GitTagBump       -> 预填命令, 回车确认
" :GitTagBump!      -> 直接执行

function! s:Git(cwd, args) abort
  "{{{
  let l:res = systemlist('git -C ' . shellescape(a:cwd) . ' ' . a:args)
  return v:shell_error ? [] : l:res
  "}}}
endfunction

function! GitTagNext(cwd) abort
  "{{{
  " 按版本号排序取最新 tag
  let l:tags = s:FugitiveGit(a:cwd, ['tag', '--sort=-v:refname'])
  if empty(l:tags)
    return ''
  endif
  let l:tag = l:tags[0]
  let l:m = matchlist(l:tag, '^\(.\{-}\)\(\d\+\)\(\D*\)$')
  if empty(l:m)
    return ''
  endif
  " 保留前缀(如 v)、位数(如 007)、后缀
  let l:num = l:m[2]
  let l:next = printf('%0' . len(l:num) . 'd', str2nr(l:num) + 1)
  return l:m[1] . l:next . l:m[3]
  "}}}
endfunction

function! GitTagBump(run) abort
  "{{{
  let l:root = s:FugitiveRoot()
  if l:root == ''
    echoerr 'Not a git repository (fugitive).'
    return
  endif

  let l:new = GitTagNext(l:root)
  if l:new == ''
    echoerr 'No tag ending with a number found.'
    return
  endif

  let l:remotes = s:FugitiveGit(l:root, ['remote'])
  if empty(l:remotes)
    echoerr 'No remote configured.'
    return
  endif
  let l:remote = index(l:remotes, 'origin') >= 0 ? 'origin' : l:remotes[0]
  let l:cmd = 'git tag ' . l:new . ' && git push ' . l:remote . ' ' . l:new
  call easy_term#Run(l:cmd, l:root, a:run)
  echo 'tag: ' . l:new
  "}}}
endfunction

command! -bang GitTagBump call GitTagBump(<bang>0)

" ---- 批量 push: 通过 fugitive 定位仓库, 找出领先上游的分支, 在 terminal 里一次 push ----
function! s:FugitiveRoot() abort
  "{{{
  if !exists('*FugitiveWorkTree')
    return ''
  endif
  let l:root = FugitiveWorkTree()
  if l:root == '' && expand('%:p:h') != ''
    let l:root = FugitiveWorkTree(expand('%:p:h'))
  endif
  return l:root
  "}}}
endfunction

function! s:FugitiveGit(root, args) abort
  "{{{
  if exists('*FugitiveExecute')
    let l:r = FugitiveExecute(a:args)
    " FugitiveExecute 第二个参数不是目录(会被当成 git 参数), 所以使用当前 buffer 的仓库
    " 过滤空行, 不依赖 stdout 末尾是否带空元素
    return l:r.exit_status ? [] : filter(copy(l:r.stdout), 'v:val !=# ""')
  endif
  return s:Git(a:root, join(map(copy(a:args), 'shellescape(v:val)'), ' '))
  "}}}
endfunction

function! GitPushAll() abort
  "{{{
  let l:root = s:FugitiveRoot()
  if l:root == ''
    echoerr 'Not a git repository (fugitive).'
    return
  endif

  let l:remotes = s:FugitiveGit(l:root, ['remote'])
  if empty(l:remotes)
    echoerr 'No remote configured.'
    return
  endif
  let l:default = index(l:remotes, 'origin') >= 0 ? 'origin' : l:remotes[0]

  let l:fmt = '%(refname:short)|%(upstream:remotename)|%(upstream:track)'
  let l:lines = s:FugitiveGit(l:root,
        \ ['for-each-ref', '--format=' . l:fmt, 'refs/heads'])

  let l:cmds = []
  let l:skip = []
  for l:line in l:lines
    let [l:br, l:remote, l:track] = split(l:line . '|', '|', 1)[0:2]
    if l:remote == ''
      " 没有上游: 推到默认 remote 并设置 upstream
      call add(l:cmds, printf('git push -u %s %s', l:default, easy_term#Escape(l:br)))
    elseif l:track =~# 'gone'
      call add(l:skip, l:br . ' (upstream gone)')
    elseif l:track =~# 'behind'
      call add(l:skip, l:br . ' (' . l:track . ')')
    elseif l:track =~# 'ahead'
      call add(l:cmds, printf('git push %s %s', l:remote, easy_term#Escape(l:br)))
    endif
  endfor
  " 本地 tag (已存在于远端的会被忽略)
  if !empty(s:FugitiveGit(l:root, ['tag']))
    call add(l:cmds, 'git push ' . l:default . ' --tags')
  endif

  if !empty(l:skip)
    echohl WarningMsg | echom 'skipped: ' . join(l:skip, ', ') | echohl None
  endif
  if empty(l:cmds)
    echo 'Nothing to push.'
    return
  endif

  call easy_term#Run(easy_term#Join(l:cmds), l:root, 1)
  "}}}
endfunction

command! GitPushAll call GitPushAll()
