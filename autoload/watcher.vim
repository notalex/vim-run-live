" Initialization {{{1

let s:error_message = ''
let s:results_window_prefix = '__Live_Results_Window__'

if !exists('g:run_live_events')
  let g:run_live_events = 'InsertLeave,BufWritePost'
endif

" }}}
" Private functions {{{1

function! s:Initialize()
  if !exists('b:live_mode_command')
    if exists('b:run_mode_command')
      let b:live_mode_command = b:run_mode_command
    else
      let s:error_message = 'Please define b:live_mode_command. See :help run_live for more details.'
    endif
  endif

  " This function should be true when no errors. When no errors !0 => 1.
  return !strlen(s:error_message)
endfunction

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
    call lib#SwitchToWindow(window_number)
  else
    call s:CreateResultsWindow(results_window_name)
    autocmd! BufWipeOut <buffer> call s:UnwatchBuffer()
  endif
endfunction

function! s:AddToResultsWindow(result)
  call s:FindOrCreateResultsWindow()
  call lib#ClearScreen()
  call lib#Append(a:result)
endfunction

function! s:RunCommandAndAddResults()
  let script = lib#GetAllContent()

  let result = system(b:live_mode_command, script)

  let working_window_number = winnr()
  call s:AddToResultsWindow(result)
  call lib#SwitchToWindow(working_window_number)
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
  if s:Initialize()
    call s:WatchBuffer()
  else
    echom s:error_message
  endif
endfunction
