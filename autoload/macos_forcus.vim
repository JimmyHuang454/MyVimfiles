let g:insert_using_im = ''
let g:im_before_focus_gain = ''
let s:normal_using_im = get(g:, 'im_normal_mode', 'com.apple.keylayout.ABC')
let s:im_cmd = get(g:, 'im_cmd', 'macism')
let s:change_cmd = get(g:, 'im_change_cmd', 'macism')

function! s:GetImType() abort
  try
    let l:saved_im = system(s:im_cmd)
  catch 
    let l:saved_im = ''
  endtry
  return l:saved_im
endfunction

function! s:SetImType(imType) abort
  if a:imType == ''
    return
  endif
  let l:temp = s:change_cmd . ' ' . a:imType
  if s:im_cmd == 'macism'
    let  l:temp = l:temp . ' 0'
  endif
  silent call system(l:temp)
endfunction

function! s:InsertEnter() abort
  if g:insert_using_im == '' || g:insert_using_im == s:normal_using_im
    return
  endif
  call s:SetImType(g:insert_using_im)
endfunction

function! s:InsertLeave() abort
  let g:insert_using_im = s:GetImType()
  if g:insert_using_im == s:normal_using_im
    return
  endif
  call s:SetImType(s:normal_using_im)
endfunction

function! s:VimFocusLost() abort
  let l:current_im = s:GetImType()
  if l:current_im == g:im_before_focus_gain
    return
  endif

  call s:SetImType(g:im_before_focus_gain)
endfunction

function! s:VimFocusGain() abort
  let g:im_before_focus_gain = s:GetImType()
  let l:is_insert = mode() == 'i'
  let l:im_should_be_used = s:normal_using_im
  if l:is_insert
    let l:im_should_be_used = g:insert_using_im
  endif

  if l:im_should_be_used == g:im_before_focus_gain
    return
  endif

  call s:SetImType(l:im_should_be_used)
endfunction

augroup macos_forcus
  autocmd!
  if get(g:, 'forcus_insert_enter', v:true)
    autocmd InsertEnter    * call s:InsertEnter()
  endif
  autocmd InsertLeavePre * call s:InsertLeave()

  autocmd VimEnter    * call s:VimFocusGain()
  autocmd VimLeavePre * call s:VimFocusLost()

  autocmd FocusGained * call s:VimFocusGain()
  autocmd FocusLost   * call s:VimFocusLost()
augroup end
