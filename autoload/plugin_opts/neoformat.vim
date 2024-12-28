nmap <leader>w :call MyFormat()<CR>
vmap <leader>w :Neoformat<CR>:w!<CR>

if has('win32')
      let g:neoformat_tex_latexindent = {
                        \ 'exe': 'latexindent',
                        \ 'args': [],
                        \ 'stdin': 1,
                        \ }
endif

fun! MyFormat() abort
      if &ft == 'markdown' && exists('g:pangu_enabled')
            exe "Pangu"
      endif

      if exists('g:did_coc_loaded') && CocAction('hasProvider', 'format') && get(g:, 'use_coc_format', 1)
            call CocActionAsync('format')
      else
            exe "Neoformat"
      endif
      exe "w!"
endf
