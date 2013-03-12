" Initialization {{{1

let s:error_message = ''
let s:results_window_prefix = '__Run_Results_Window__'

" }}}
" Private functions {{{1

function! s:Initialize()
  if !exists('b:run_mode_command')
    if exists('b:live_mode_command')
      let b:run_mode_command = b:live_mode_command
    else
      let s:error_message = 'Please define b:run_mode_command. See :help run_live for more details.'
    endif
  endif

  " This function should be true when no errors. When no errors !0 => 1.
  return !strlen(s:error_message)
endfunction

function! s:ResultsWindowName()
  return s:results_window_prefix . bufnr('%')
endfunction

function! s:CreateResultsWindow()
  call run_live_lib#CreateTemporaryWindow('rightbelow split', s:ResultsWindowName())
endfunction

function! s:AddToResultsWindow(result)
  call s:CreateResultsWindow()
  call run_live_lib#ClearScreen()
  call run_live_lib#Append(a:result)
  call run_live_lib#AdjustWindowHeight()
endfunction

function! s:RunBuffer(visualmode)
  if a:visualmode
    let script = run_live_lib#GetSelectedContent()
  else
    let script = run_live_lib#GetAllContent()
  endif

  let result = system(b:run_mode_command, script)

  call run_live_lib#CloseWindow(s:ResultsWindowName())

  if strlen(result)
    let working_window_number = winnr()
    call s:AddToResultsWindow(result)
    call run_live_lib#SwitchToWindow(working_window_number)
  else
    echom 'No results to display.'
  endif
endfunction

" }}}

function! runner#InitializeAndRun(visualmode)
  if s:Initialize()
    call s:RunBuffer(a:visualmode)
  else
    echom s:error_message
  endif
endfunction
