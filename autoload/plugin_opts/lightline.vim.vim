let g:buffer_workspace = {}
let g:windows_length = {}
let g:lightline = {'colorscheme': 'PaperColor'}
let g:lightline['component'] = {'workspace': '%{MyGetWorkSpace()}', 'ECY_engine': '%{ECYEngine()}'}
let g:lightline['active'] = {
    \ 'left': [ [ 'mode', 'paste'],
    \           [ 'readonly', 'filename', 'modified', 'workspace'] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'ECY_engine' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ]
    \          ]}

let g:lightline['inactive'] = {
    \ 'left': [ [ 'filename', 'workspace'] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ] ] }

let g:lightline_workspace_max_length = get(g:, 'lightline_workspace_max_length', 60)

function! GetPathAbbr(full_path, current_width)
  let l:return_result = ''
  let l:cutting_path = a:full_path
  let i = 0
  while i < 200
    let l:temp = fnamemodify(l:cutting_path, ':t')
    let l:return_result = l:temp . '/' .l:return_result
    let l:cutting_path = fnamemodify(l:cutting_path, ':h')
    if strlen(l:return_result) >= (a:current_width / 2) || l:temp == '' || 
          \strlen(l:return_result) >= g:lightline_workspace_max_length
      let l:return_result = './' . l:return_result
      break
    endif
    let i += 1
  endw
  return l:return_result
endfunction

function! MyGetWorkSpace()
  if !exists('g:loaded_rooter')
    return ''
  endif
  let l:bufnr = bufnr()
  let l:current_window_width = winwidth(0)
  if !has_key(g:buffer_workspace, l:bufnr)
    let g:buffer_workspace[l:bufnr] = GetPathAbbr(FindRootDirectory(), l:current_window_width)
    let g:windows_length[l:bufnr] = {}
    let g:windows_length[l:bufnr]['last_width'] = l:current_window_width
  endif
  if g:windows_length[l:bufnr]['last_width'] != l:current_window_width
    unlet g:buffer_workspace[l:bufnr]
    return MyGetWorkSpace()
  endif
  return g:buffer_workspace[l:bufnr]
endfunction

function! ECYEngine()
  if !exists('g:loaded_easycomplete')
    return ''
  endif
  return ECY_main#GetCurrentUsingSourceName()
endfunction
