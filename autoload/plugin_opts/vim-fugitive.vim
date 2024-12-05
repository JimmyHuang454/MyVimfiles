nmap <Leader>g :Git<cr>
nmap <Leader>p :Git push<cr>

" must put these outside a function
let s:base_dir = expand( '<sfile>:p:h' )
let s:base_dir = tr(s:base_dir, '\', '/')

function! PushAllRemote() abort
   let l:path = s:base_dir . '/git_push_remote.bat'
   call TermStart(l:path, '')
endfunction
