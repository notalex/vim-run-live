" Initialization {{{1

let s:results_window_prefix = '__Run_Results_Window__'

" }}}
" Private functions {{{1

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
  let error_message = run_live_init#CommandSetup('run_mode')

  if strlen(error_message)
    echom error_message
  else
    call s:RunBuffer(a:visualmode)
  endif
endfunction
