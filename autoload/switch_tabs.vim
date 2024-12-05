
function! s:OnTabLeave() abort
  let s:last_tab_nr = tabpagenr()
endfunction

function! s:Getchar()
    "{{{
    let l:c = getchar()
    let l:c = nr2char(l:c)
    return l:c
    "}}}
endfunction

function! MyGotoTab() abort
"{{{
  echom 'Input the number of tabs that you want to go:'
  let l:tabNr = s:Getchar()
  redraw!
  if l:tabNr =~ '\d'
    let l:tabscount = tabpagenr('$')
    if l:tabNr > l:tabscount
      echo "Have no such a tab number."
      return
    endif
    if l:tabNr * 10 <= l:tabscount
      echom 'Input the number of tabs that you want to go:' . l:tabNr
      let l:tabNr2 = s:Getchar()
      redraw!
      if l:tabNr2 =~ '\d'
        let l:tabNr = l:tabNr * 10 + l:tabNr2
      endif
    endif
    silent! execute 'tabnext '. l:tabNr
  else
    echo 'Quit to Tabsmanager.'
  endif
"}}}
endfunction

function! MySwitchTab() abort
"{{{
  if s:last_tab_nr != -1
    silent! execute 'tabnext '. s:last_tab_nr
    echo "Last tabs: " string(s:last_tab_nr)
  else
    echo "Have no last tab."
  endif
"}}}
endfunction

function! s:Init() abort
  let s:last_tab_nr = -1
  au! TabLeave * call s:OnTabLeave()
  nmap gt :call MySwitchTab()<CR>
  nmap tg :call MyGotoTab()<CR>
endfunction

call s:Init()
