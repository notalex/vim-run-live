" Initialization {{{1

if exists('g:loaded_vim_live_mode')
  finish
else
  let g:loaded_vim_live_mode = 1
endif

command! WatchBuffer call watcher#InitializeAndWatchBuffer()
