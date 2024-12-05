function! s:OnInsertMode() abort 
"{{{
  call s:DoCompletion()
"}}}
endfunction

function! s:DoCompletion() abort 
"{{{
  let l:line = getline('.')
  let l:start = col('.') - 1
  while l:start > 0 &&  l:line[l:start - 1] =~ '\a'
    let l:start -= 1
  endwhile
  if s:position_colum != l:start
    call g:PrepareContent()
  endif
  let s:position_colum = l:start
  let l:word = l:line[l:start: col('.') - 1]
  if strlen(l:word) <= g:trigger_length
    return
  endif
  let s:item_list = g:FuzzyMatch(s:items_dict['words'], l:word, 'abbrs')
  if len(s:item_list) == 0
    return
  endif
  call feedkeys("\<C-X>\<C-U>\<C-P>", 'in' )
"}}}
endfunction

function! s:OnTextChangedInsertMode() abort 
"{{{
  call s:DoCompletion()
"}}}
endfunction

function! s:OnBufferEnter() abort
"{{{
  call g:PrepareContent()
"}}}
endfunction

function! s:OnInsertChar() abort
"{{{
  if pumvisible()
    call feedkeys("\<C-e>", 'in')
  endif
"}}}
endfunction

function! s:Init() abort
"{{{
  let s:items_dict = {}
  let s:position_colum = -1
  let g:trigger_length
        \= get(g:, 'trigger_length', 1)
  autocmd InsertEnter   * call s:OnInsertMode()
  autocmd TextChangedI  * call s:OnTextChangedInsertMode()
  autocmd InsertCharPre * call s:OnInsertChar()
  autocmd BufEnter      * call s:OnBufferEnter()
  set completeopt-=menu
  set completeopt+=menuone
  set completeopt-=longest
  set shortmess+=c
  set completefunc=CompleteMonths
  inoremap <expr> <tab>
        \ pumvisible()? "\<c-n>" : "\<tab>"
  inoremap <expr> <s-tab>
        \ pumvisible()? "\<c-p>" : "\<s-tab>"
"}}}
endfunction

function! g:PrepareContent() abort
"{{{
  let s:items_string = join(getbufline(bufnr(), 1, "$"), "\n")
  let l:split = split(s:items_string, '\W\+')
  let l:temp = []
  for item in l:split
    let l:words = {'abbrs': '', 'word': '', 'kind': '[ID]','menu': '', 'info': '', 'user_data': ''}
    let l:words['abbrs'] = tolower(item)
    let l:words['word'] = item
    call add(l:temp, l:words)
  endfor
  let s:items_dict = {'words': l:temp}
"}}}
endfunction

fun! CompleteMonths(findstart, base)
  if a:findstart
    return s:position_colum
  else
    return {'words': s:item_list}
  endif
endfun

function! g:FuzzyMatch(items, patten, filter_item) abort
"{{{
  let i = 0
  let l:items_len = len(a:items)
  let g:abc = l:items_len
  let l:regex = ''
  let l:regex2 = ''
  while i < len(a:patten)
    let l:regex .= '\w\{}' . a:patten[i]
    let l:regex2 .= '\w\{0,1}' . a:patten[i]
    let i += 1
  endwhile
  let l:regex3 = '^' . a:patten
  
  let l:sort_list = []
  for item in a:items
    if a:filter_item == 'ALL'
        let l:abbr = ''
        for [key_name,value] in items(item)
          let l:abbr .= value
        endfor
    else
      try
        let l:abbr = item[a:filter_item]
      catch
        let l:abbr = ''
      endtry
    endif
    if !(l:abbr =~ l:regex)
      continue
    endif
    " if l:items_len > 4000
    "   if l:items_len > 8000
    "     if !(l:abbr =~ l:regex3)
    "       continue
    "     endif
    "   else
    "     if !(l:abbr =~ l:regex2)
    "       continue
    "     endif
    "   endif
    " endif
    let l:goal = 0
    let l:match_point = []
    let i = 0
    while len(a:patten) > i
      let l:position_normal = match(l:abbr,a:patten[i])

      " let l:position_upper = match(l:abbr,toupper(a:patten[i]))
      " if l:position_upper < l:position_normal && l:position_upper != -1
      "   let l:position_normal = l:position_upper
      " endif

      if l:position_normal == -1
        let l:goal += 1000
        break
      else
        let l:goal += l:position_normal
        call add(l:match_point,l:goal)
        let l:abbr = l:abbr[l:position_normal:]
      endif
      let i += 1
    endw
    let item['goal'] = l:goal
    let item['match_point'] = l:match_point
    
    " call add(l:sort_list, item)
    let l:sorted_list_len =  len(l:sort_list)
    if l:sorted_list_len == 0
      call add(l:sort_list, item)
      continue
    endif
    if l:goal >= 1000
      continue
    endif
    let i = l:sorted_list_len
    while i > 0
      if l:sort_list[i-1]['goal'] < l:goal
        " switch 
        break
      endif
      let i -= 1
    endwhile

    " add item before i
    call insert(l:sort_list,item,i)
    if len(l:sort_list) > 50
      call remove(l:sort_list,len(l:sort_list)-1)
    endif
  endfor
  " let l:return = sort(l:sort_list, "MyCompare")
  
  let l:return = []
  for item in l:sort_list
    if item['goal'] < 1000
      call add(l:return, item)
    endif
  endfor
  return l:return
"}}}
endfunction

call s:Init()
