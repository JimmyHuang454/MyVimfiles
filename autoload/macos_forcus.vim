let s:insert_using_im = ''
let s:im_before_focus_gain = ''
let s:normal_using_im = get(g:, 'im_normal_mode', 'com.apple.keylayout.ABC')
let s:im_cmd = get(g:, 'im_cmd', 'macism')

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
  let l:temp = s:im_cmd . ' ' . a:imType
  if s:im_cmd == 'macism'
    let  l:temp = l:temp . ' 0'
  endif
  silent call system(l:temp)
endfunction

function! s:InsertEnter() abort
  if s:insert_using_im == '' || s:insert_using_im == s:normal_using_im
    return
  endif
  call s:SetImType(s:insert_using_im)
endfunction

function! s:InsertLeave() abort
  let s:insert_using_im = s:GetImType()
  if s:insert_using_im == s:normal_using_im
    return
  endif
  call s:SetImType(s:normal_using_im)
endfunction

function! s:VimFocusLost() abort
  call s:SetImType(s:im_before_focus_gain)
endfunction

function! s:VimFocusGain() abort
  let s:im_before_focus_gain = s:GetImType()
  let l:temp = s:normal_using_im
  if mode() == 'i'
    let l:temp = s:insert_using_im
  endif
  call s:SetImType(l:temp)
endfunction

augroup macos_forcus
  autocmd!
  " autocmd InsertEnter    * call s:InsertEnter()
  autocmd InsertLeavePre * call s:InsertLeave()

  autocmd VimEnter    * call s:VimFocusGain()
  autocmd VimLeavePre * call s:VimFocusLost()

  autocmd FocusGained * call s:VimFocusGain()
  autocmd FocusLost   * call s:VimFocusLost()
augroup end
