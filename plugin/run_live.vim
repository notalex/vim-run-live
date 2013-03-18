if exists('g:loaded_run_live')
  finish
else
  let g:loaded_run_live = 1
endif

call run_live_lib#InitializeGlobalVariable('remember_shell_command')
call run_live_lib#InitializeGlobalVariable('results_window_skip_threshold')

" Live Mode {{{1

command! WatchBuffer call watcher#InitializeAndWatchBuffer()

"}}}
" Run Mode {{{

if !exists('g:run_mode_map')
  let g:run_mode_map = '<Leader>r'
endif

execute 'nnoremap ' . g:run_mode_map . ' :call runner#InitializeAndRun(0)<cr>'
execute 'vnoremap ' . g:run_mode_map . ' :<c-u>call runner#InitializeAndRun(1)<cr>'

"}}}
