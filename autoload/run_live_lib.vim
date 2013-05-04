" Should contain independent reusable functions.

" Initialization {{{1

if exists('g:loaded_run_live_lib')
  finish
else
  let g:loaded_run_live_lib = 1
  let s:bypass_threshold_check = 0
endif

" }}}

function! run_live_lib#SwitchToWindow(window_number)
  execute a:window_number . 'wincmd w'
endfunction

function! run_live_lib#Append(result)
  call append(0, split(a:result, '\v\n'))
  normal! gg
endfunction

function! run_live_lib#ClearScreen()
  normal! ggdG
endfunction

function! run_live_lib#GetAllContent()
  let lines = getline(1, '$')
  let all_content = join(lines, "\n")
  return all_content
endfunction

function! run_live_lib#GetSelectedContent()
  let user_yanked_content = @@

  silent execute "normal! `<v`>y"
  let selected_content = @@

  let @@ = user_yanked_content

  return selected_content
endfunction

function! run_live_lib#CloseWindow(window_name)
  let window_number = bufwinnr(a:window_name)

  if window_number > 0
    let s:bypass_threshold_check = 1
    call run_live_lib#SwitchToWindow(window_number)
    wincmd q
  endif
endfunction

function! run_live_lib#CreateTemporaryWindow(split_type, window_name)
  execute a:split_type . ' ' . a:window_name
  setlocal bufhidden=wipe buftype=nofile
endfunction

" When content is lesser than window height, reduce height to match content.
function! run_live_lib#AdjustWindowHeight()
  let results_window_height = winheight('.')
  let content_height = line('$')
  let adjusted_height = min([results_window_height, content_height])
  execute 'resize ' . adjusted_height
endfunction

function! run_live_lib#InitializeGlobalVariable(variable_name)
  let variable_name = 'run_live_' . a:variable_name

  if !exists('g:{variable_name}')
    let g:{variable_name} = 0
  endif
endfunction

function! run_live_lib#SetupUpSkipper()
  if g:run_live_results_window_skip_threshold
    autocmd! BufEnter <buffer> :call run_live_lib#SkipResultsWindow()
  endif
endfunction

function! run_live_lib#SkipResultsWindow()
  if s:bypass_threshold_check
    let s:bypass_threshold_check = 0
  elseif len(tabpagebuflist()) > g:run_live_results_window_skip_threshold
    wincmd w
  endif
endfunction
