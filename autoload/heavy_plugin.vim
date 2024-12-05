for item in get(g:, 'pre_load_plugins', [])
  call g:LoadPlugin(item)
endfor

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            rely on git and vimL                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if g:has_git
  call g:LoadPlugin('airblade/vim-gitgutter')
  call g:LoadPlugin('tpope/vim-fugitive')
  call g:LoadPlugin('Xuyuanp/nerdtree-git-plugin')
  call g:LoadPlugin('tpope/vim-dispatch') " for vim-fugitive
endif

if g:is_neovim && get(g:, 'use_tree_in_neovim', v:false)
  call g:LoadPlugin('nvim-treesitter/nvim-treesitter')
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                          rely on python3 or job and vimL                    
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call g:LoadPlugin('https://gitee.com/Jimmy_Huang/mysnippets')
call g:LoadPlugin('honza/vim-snippets')

"{{{ filter
if !get(g:, 'use_coc_list', v:false)
  if g:has_python3 && get(g:, 'use_leaderf', v:true)

    if get(g:, 'build_leaderf_c_extension', v:false)
      call g:LoadPlugin('Yggdroot/LeaderF', { 'do': '.\install.bat' })
    elseif exists('g:leaderf_tag')
      call g:LoadPlugin('Yggdroot/LeaderF', {'tag': g:leaderf_tag})
    else
      call g:LoadPlugin('Yggdroot/LeaderF')
    endif
    call g:LoadPlugin('tamago324/LeaderF-filer')
    call g:LoadPlugin('Yggdroot/LeaderF-marks')

  elseif get(g:, 'use_vim_clap', v:false) && has('patch-8.1.2114')
    if !exists('g:clap_tag')
      call g:LoadPlugin('liuchengxu/vim-clap')
    else
      call g:LoadPlugin('liuchengxu/vim-clap', {'tag': g:clap_tag})
    endif
  else 
    call g:LoadPlugin('ctrlpvim/ctrlp.vim')
  endif
endif
"}}}

let g:loaded_completion = v:false"{{{

if g:has_job
  " call g:LoadPlugin('Chiel92/vim-autoformat')
  call g:LoadPlugin('sbdchd/neoformat')
  call g:LoadPlugin('https://gitee.com/Jimmy_Huang/ecy-terminal')
  if get(g:, 'use_vim_lsp', v:false)
    call g:LoadPlugin('mattn/vim-lsp-settings')
    call g:LoadPlugin('prabirshrestha/vim-lsp')
  endif
  if get(g:, 'use_ECY', v:false)
    if !get(g:,'ECY_development', v:false)
      call g:LoadPlugin('JimmyHuang454/EasyCompleteYou')
    endif
    call g:LoadFile('plugin_opts/MyECY.vim', 0)
    if g:has_python3
      call g:LoadPlugin('SirVer/ultisnips')
    endif
  else
    call g:LoadPlugin('airblade/vim-rooter')
    if get(g:, 'use_coc', v:true)
      call g:LoadPlugin('neoclide/coc.nvim', {'branch': 'release'})
    endif
  endif
  let g:loaded_completion = v:true
endif

if !g:loaded_completion && !get(g:, 'do_not_use_completion', v:false)
  call g:LoadFile('completion.vim', 0)
endif"}}}

call g:LoadPlugin('MarcWeber/vim-addon-mw-utils')
call g:LoadPlugin('tomtom/tlib_vim')
call g:LoadPlugin('thinca/vim-themis')
call g:LoadPlugin('lervag/vimtex')
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

if g:is_macvim
  call g:LoadPlugin('JimmyHuang454/smartim')
endif
