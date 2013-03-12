" Initialization {{{1

if exists('g:loaded_vim_run_mode')
  finish
else
  let g:loaded_vim_run_mode = 1
endif

if !exists('g:run_mode_map')
  let g:run_mode_map = '<localleader>r'
endif

execute 'nnoremap ' . g:run_mode_map . ' :call runner#InitializeAndRun(0)<cr>'
execute 'vnoremap ' . g:run_mode_map . ' :<c-u>call runner#InitializeAndRun(1)<cr>'
