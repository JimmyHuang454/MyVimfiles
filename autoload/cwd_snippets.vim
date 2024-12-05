""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                auto detect if there snippets defined in CWD                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:Init()
  let g:cwd_snippets_dir = {}
  autocmd BufEnter   * call s:OnBufferEnter()
endf

fun! s:OnBufferEnter()
  if !exists('g:UltiSnipsSnippetDirectories') || 
        \exists('b:cwd') || !exists('g:loaded_rooter')
    return
  endif

  let l:current_cwd = FindRootDirectory()
  let b:cwd = l:current_cwd

  if !has_key(g:cwd_snippets_dir, l:current_cwd) && l:current_cwd != ''
    let g:cwd_snippets_dir[l:current_cwd] = ''
    let l:cwd_file = readdir(l:current_cwd)
    for item in l:cwd_file
      let l:full_path = l:current_cwd . '/'. item
      if !isdirectory(l:full_path)
        continue
      endif

      if item =~ 'snippets'
        call add(g:UltiSnipsSnippetDirectories, l:full_path)
        break
      endif
    endfor
  endif
endf

call s:Init()
