" Initialization {{{1

if exists('g:loaded_run_live_watcher')
  finish
else
  let g:loaded_run_live_watcher = 1
endif

let s:results_window_prefix = '__Live_Results_Window__'

if !exists('g:run_live_events')
  let g:run_live_events = 'InsertLeave,BufWritePost'
endif

" }}}
" Private functions {{{1

function! s:ResultsWindowName()
  return s:results_window_prefix . bufnr('%')
endfunction

function! s:CreateResultsWindow(results_window_name)
  call run_live_lib#CreateTemporaryWindow('rightbelow vsplit', a:results_window_name)
endfunction

function! s:FindOrCreateResultsWindow()
  let results_window_name = s:ResultsWindowName()
  let window_number = bufwinnr(results_window_name)

  if window_number > 0
    call run_live_lib#SwitchToWindow(window_number)
  else
    call s:CreateResultsWindow(results_window_name)
    autocmd! BufWipeOut <buffer> call s:UnwatchBuffer()
  endif
endfunction

function! s:AddToResultsWindow(result)
  call s:FindOrCreateResultsWindow()
  call run_live_lib#ClearScreen()
  call run_live_lib#Append(a:result)
endfunction

function! s:RunCommandAndAddResults()
  let script = run_live_lib#GetAllContent()

  let result = system(b:live_mode_command, script)

  let working_window_number = winnr()
  call s:AddToResultsWindow(result)
  call run_live_lib#SwitchToWindow(working_window_number)
endfunction

function! s:UnwatchBuffer()
  silent! autocmd! WatchBufferAuGroup * <buffer>
endfunction

function! s:WatchBuffer()
  call s:RunCommandAndAddResults()

  augroup WatchBufferAuGroup
    execute 'autocmd! ' . g:run_live_events ' <buffer> call s:RunCommandAndAddResults()'
  augroup END
endfunction

" }}}

function! watcher#InitializeAndWatchBuffer()
  let error_message = run_live_init#CommandSetup('live_mode')

  if strlen(error_message)
    echom error_message
  else
    call s:WatchBuffer()
  endif
endfunction
