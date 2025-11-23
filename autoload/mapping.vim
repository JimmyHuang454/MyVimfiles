let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               vim's mapping                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if g:is_macvim
  let did_install_default_menus = 1
  map <D-x> :q<cr>
  imap <D-x> <esc>:q<cr>
  map <D-s> :wa<cr>
  imap <D-s> <esc>:wa<cr>
  imap <D-f> <C-w>
  tmap <D-x> <C-w>:quit!<CR>
else
  map <A-x> :q<cr>
  imap <A-x> <esc>:q<cr>
  map <A-s> :wa<cr>
  imap <A-s> <esc>:wa<cr>
  imap <A-f> <C-w>
  tmap <A-x> <C-w>:quit!<CR>
endif

nmap ff :q<cr>

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
nmap <PageDown> <PageDown>zz
nmap <PageUp> <PageUp>zz

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
  if g:is_windows
    tmap <A-x> <C-w><C-c>:quit!<CR>
  else
    tmap <A-x> <C-w>:quit!<CR>
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
