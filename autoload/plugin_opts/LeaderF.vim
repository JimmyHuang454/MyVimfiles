let g:Lf_PopupPreviewPosition = 'cursor'

let g:Lf_WildIgnore = {
      \ 'dir': ['.svn','.git','.hg'],
      \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
      \}
let g:Lf_CommandMap = {'<F5>': ['<C-a>']}
let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 0,
        \ 'Mru': 0,
        \ 'Tag': 0,
        \ 'BufTag': 0,
        \ 'Function': 0,
        \ 'Line': 0,
        \ 'Colorscheme': 0,
        \ 'Rg': 0,
        \ 'Gtags': 0
        \}

if g:is_windows
  let g:Lf_Ctags = g:my_root . '/autoload/data/ctags.exe'
endif

let g:Lf_PreviewCode = 1
let g:Lf_HistoryNumber = 10000
let g:Lf_MruMaxFiles = 10000
let g:Lf_RootMarkers = ['.root', '.git']
let g:Lf_WorkingDirectoryMode = 'a'
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_WindowPosition = 'popup'
let g:Lf_WindowHeight = 0.30
" let g:Lf_RecurseSubmodules = 1
let g:Lf_ShowDevIcons = 0
let g:always_leaderf = 1

nmap gm :LeaderfMru<cr>
nmap gb :LeaderfBufferAll<cr>
nmap gw :LeaderfWindow<cr>
nmap g; :LeaderfHistoryCmd<cr>
nmap gf :LeaderfSelf<cr>
nmap <Leader>d :LeaderfLine <cr>
nmap <Leader>a :call MySelectSymbols()<cr>
nmap <Leader>m :LeaderfMarks<cr>

let g:leaderf_rg_CMD = get(g:, 'leaderf_rg_CMD', 'rg')
if executable(g:leaderf_rg_CMD)
  " seach current project file wiht its name.
  nmap <Leader>f :execute('Leaderf file ' . FindRootDirectory())<cr>
  " seach current project file's text.
  nmap <Leader>s :execute(LeaderfRgSearch(0, ''))<cr>
  " seach current word under cursor in normal mode in that project.
  nmap gs :execute(LeaderfRgSearch(1, expand("<cword>")))<cr>
  " seach seleted word in selete mode in that project.
  xnoremap gs :<C-U><C-R>=LeaderfRgSearch(2, leaderf#Rg#visual())<CR><CR>
endif
  

function! LeaderfRgSearch(is_immediate, visual_selected)
"{{{
  let l:workspace = FindRootDirectory()
  if l:workspace == ''
    let l:workspace = '.'
  endif

  if a:is_immediate == 1 || a:is_immediate == 2
    let l:is_immediate  = '!'
    if a:is_immediate == 2
      " in selete mode.
      let l:position_word = '-e ' . a:visual_selected
    else
      let l:position_word = '-w ' . a:visual_selected
    endif
  elseif a:is_immediate == 0
    let l:is_immediate = ''
    let l:position_word = '""'
  endif

  let g:leaderf_rg_cace_sensitive = get(g:, 'leaderf_rg_cace_sensitive', '-s')
  " -s case sensitive.
  let l:cmd = printf("Leaderf%s rg %s %s %s ", 
        \l:is_immediate, g:leaderf_rg_cace_sensitive,l:position_word, l:workspace)
  return l:cmd
"}}}
endf

function! MySelectSymbols()
"{{{
  if !exists('g:loaded_easycomplete') || exists('g:always_leaderf')
    execute "LeaderfFunction"
    return
  endif
  if ECY#utility#CheckCurrentCapabilities('Find-document-symbols')
    execute "ECYDocumentSymbols"
    return
  endif
  if ECY#utility#CheckCurrentCapabilities('Find-workspace-symbols')
    execute "ECYWorkSpaceSymbols"
    return
  endif
  execute "LeaderfFunction"
"}}}
endf
