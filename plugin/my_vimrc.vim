if exists('g:loaded_myvimrc')
  finish
endif
let g:loaded_myvimrc = 1
let g:loaded_erro = []
let g:is_vim = !has('nvim')

let g:my_root = tr(expand('<sfile>:p:h:h'), '\', '/')

function! g:LoadFile(file_name, is_buildin) abort
"{{{
  if a:is_buildin
    execute 'source ' . a:file_name
  else
    execute 'source ' . g:my_vimrc_file_dir . '/' . a:file_name
  endif
"}}}
endfunction

function! g:LoadPlugin(plug_command, ...) abort
"{{{
  if a:0 > 0
    let l:temp = "Plug '". a:plug_command . "'," . string(a:1)
  else
    let l:temp = "Plug '" . a:plug_command ."'"
  endif
  let l:plugin_name = fnamemodify(a:plug_command, ':t')
  " let l:plugin_name = tr(l:plugin_name, '.', '-')
  let l:plugin_opts_path = 'plugin_opts/' . l:plugin_name . '.vim'
  if filereadable(g:my_vimrc_file_dir . '/'. l:plugin_opts_path)
    try
      call g:LoadFile(l:plugin_opts_path, 0)
    catch 
      call add(g:loaded_erro, v:exception)
    endtry
  endif
  if g:loaded_erro != []
    echo "There are erros when loading Myvimrc."
  endif
  execute l:temp
"}}}
endfunction

