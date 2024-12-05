let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_max_num_candidates = 0
let g:ycm_semantic_triggers =  {
      \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{3}'],
      \ 'cs,lua,javascript': ['re!\w{3}'],
      \ }

nmap gf :YcmCompleter GoTo<cr>
