let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               vim's mapping                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call MapAlt('map <A-c> :q<cr>', 'c')
call MapAlt('imap <A-c> <ESC>q<cr>', 'c')
call MapAlt('map <A-w> :w<cr>', 'wa')
call MapAlt('imap <A-w> <ESC>:w<cr>', 'wa')

call MapAlt('map <A-x> :q!<cr>', 'x')
call MapAlt('imap <A-x> <ESC>:q!<cr>', 'x')

call MapAlt('imap <A-f> <C-w>', 'f')

map gj <C-w>j
map gk <C-w>k
map gh <C-w>h
map gl <C-w>l

nmap j jzz
nmap k kzz

nmap 8 *N
nmap 9 $
nmap Y y$
vmap 9 $

map fd <C-d>zz
map fe <C-u>zz
nmap <leader>q :%s/\r//g<CR>

map <leader>y :let @+ = GetCurrentBufferPath()<CR>

map <silent> <leader>l 
      \:call RunCMD
      \(
      \[printf("clang %s -o %s/test.exe", GetCurrentBufferPath(), GetCurrentBufferDir()), 
      \printf("%s/test.exe", GetCurrentBufferDir())]
      \,'')<CR>

nmap <leader>j :call GotoLine()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Plugins mapping                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
map gn :exec("NERDTree ".expand('%:p'))<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

if g:has_terminal
  call MapAlt('tmap <A-c> <C-w>:hide<CR>', 'c')
  if g:is_windows
    call MapAlt('tmap <A-x> <C-w><C-c>:quit!<CR>', 'x')
  else
    call MapAlt('tmap <A-x> <C-w>:quit!<CR>', 'x')
  endif
  tmap gj <C-w><C-j>
  tmap gk <C-w><C-k>
  tmap gh <C-w><C-h>
  tmap gl <C-w><C-l>
  tmap gt <C-w>gt
  tmap <Esc> <C-w>N
endif

function! StartFlutterTest() abort
  let current_file = expand('%:p')
  let obj = easy_term#NewEasyTermial()
  call obj._new_terminal()
  call obj._feedkey(printf("dart test \"%s\"\<CR>", current_file))
endfunction

nmap <Leader>t :call StartFlutterTest()<cr>
