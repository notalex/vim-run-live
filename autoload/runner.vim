" Initialization {{{1

if exists('g:loaded_run_live_runner')
  finish
else
  let g:loaded_run_live_runner = 1
endif

let s:results_window_prefix = '__Run_Results_Window__'
let s:working_window_number = 1

" }}}
" Private functions {{{1

function! s:ResultsWindowName()
  return s:results_window_prefix . bufnr('%')
endfunction

function! s:AddToResultsWindow(result)
  call run_live_lib#FindOrCreateWindowByName(s:ResultsWindowName())
  call run_live_lib#ClearScreen()
  call run_live_lib#Append(a:result)
  call run_live_lib#SetupUpSkipper()
  call run_live_lib#AdjustWindowHeight()
endfunction

function! s:SaveWorkingWindow()
  let s:working_window_number = winnr()
  let b:first_visible_line_number = line('w0')
  normal! m'
endfunction

function! s:RestoreWorkingWindow()
  call run_live_lib#SwitchToWindow(s:working_window_number)
  execute "keepjumps normal! " . b:first_visible_line_number . "gg"
  normal! zt
  keepjumps normal! g`'
endfunction

function! s:RunBuffer(visualmode)
  if a:visualmode
    let s:content_list = run_live_lib#GetSelectedContentList()
  else
    let s:content_list = run_live_lib#GetContentList()
  endif

  let s:content_file = run_live_lib#WriteToFile(s:content_list)
  let result = system(b:run_mode_command . ' ' . s:content_file)

  if strlen(result)
    call s:SaveWorkingWindow()
    call s:AddToResultsWindow(result)
    call s:RestoreWorkingWindow()
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
