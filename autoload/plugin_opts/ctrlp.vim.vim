let g:ctrlp_by_filename = 1

nmap <Leader>d :exec("CtrlPLine " . bufname())<CR>
nmap <Leader>a :CtrlPTag<cr>
nmap <Leader>f :CtrlP<cr>
nmap gm :CtrlPMRU<cr>
nmap gb :CtrlPBuffer<cr>
