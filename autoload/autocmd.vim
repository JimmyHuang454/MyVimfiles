""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               vim's autocmd                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:AutoFF()
"{{{
  let l:ft = &fileformat
  let l:ignore_file_type = ['nerdtree', 'fugitive', 'help', 'unix']
  if !s:CheckIgnore(l:ignore_file_type, l:ft)
    try
      execute "normal! :e ++ff=unix\<CR>"
      echo "You had reopen this file with unix format."
    catch 
    endtry
  endif
"}}}
endfunction

function! s:CheckIgnore(lists, compare) abort
  for item in a:lists
    if item == a:compare
      return v:true
    endif
  endfor
  return v:false
endfunction

function! s:OnBufferEnter() abort
  if g:is_windows
    call s:AutoFF()
  endif

  call g:LoadFile('lang/dart.vim', 0)
endfunction

function! s:Init() abort
  au! BufEnter * call s:OnBufferEnter()
  call g:LoadFile('switch_tabs.vim', 0)
endfunction

call s:Init()
