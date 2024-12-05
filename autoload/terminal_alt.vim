let s:macvim_alt_map = {"c": "ç", "w": "∑","x": "≈", 'f': "ƒ"}
fun! MapAlt(cmd, key)
    if g:is_macvim
        exe substitute(a:cmd, "<A-" . a:key . ">", s:macvim_alt_map[a:key], 'g')
    elseif g:is_windows
        exe a:cmd
    else
        exec "set <M-".a:key.">=\ed".a:key
    endif
endf
