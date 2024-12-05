nmap <silent> <m-j> <Plug>CycleNext
vmap <silent> <m-j> <Plug>CycleNext
nmap <silent> <m-k> <Plug>CyclePrev
vmap <silent> <m-k> <Plug>CyclePrev
let g:cycle_default_groups = [
			\   [['true', 'false']],
			\   [['True', 'False']],
			\   [['and', 'or', 'is']],
			\   [['yes', 'no']],
			\   [['\', '/']],
			\   [['++', "--"]],
			\   [['+', '-', '_']],
			\   [['>', '<']],
			\   [[';', ':']],
			\   [['"', "'"]],
			\   [['==', '!=', '&&', '||']],
			\ ]
