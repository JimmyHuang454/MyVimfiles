fun! s:Init()
  
endf

fun! MyFormat()
    if &ft != 'markdown'
      return
    endif
    let l:current_buffer_content = getbufline(bufnr(), 1, "$")
    for item in l:current_buffer_content
      let l:len = widthlen(item)
      for key in item
        
      endfor
      
    endfor
endf

call s:Init()
