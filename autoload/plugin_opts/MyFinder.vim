nmap gm :FinderMRU<cr>
nmap gb :FinderBuffer<cr>
nmap gw :FinderWindow<cr>
nmap g; :FinderHistory<cr>
nmap <Space>d :FinderLine <cr>
nmap <Space>m :FinderMark<cr>
nmap <Space>f :FinderFiles<cr>
nmap <Space>a :FinderCtagsFile<cr>
nmap <Space>s :FinderRgAllLine <cr>

" fugitive 页面(:Git / commit / log)里, 光标放在 commit 上查看改动的文件
augroup MyVimrcFinderGitDiff
  autocmd!
  autocmd FileType fugitive,git nnoremap <buffer><silent> <leader>v :FinderGitDiff<CR>
augroup END
