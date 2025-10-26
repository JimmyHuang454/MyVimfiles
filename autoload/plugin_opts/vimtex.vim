if g:is_windows && executable('texworks')
  let g:vimtex_view_general_viewer = 'texworks'
else g:is_macvim
  let g:vimtex_view_method = 'skim'
endif
" let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
" let g:vimtex_view_general_options_latexmk = ''
let g:vimtex_quickfix_enabled = 0
let g:vimtex_quickfix_mode = 1
