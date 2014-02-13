" Should contain independent reusable functions.

" Initialization {{{1

if exists('g:loaded_run_live_lib')
  finish
else
  let g:loaded_run_live_lib = 1
  let s:bypass_threshold_check = 0
endif

" }}}

" Private {{{1

function! s:IsHorizontalSplit()
  let l:buffer_window_number = bufwinnr('%')
  wincmd k

  if bufwinnr('%') == l:buffer_window_number
    let l:is_horizontal_split = 0
  else
    call <SID>BypassThresholdCheckAndSwitchWindow(l:buffer_window_number)
    let l:is_horizontal_split = 1
  endif

  return l:is_horizontal_split
endfunction

function! s:BypassThresholdCheckAndSwitchWindow(window_number)
  let s:bypass_threshold_check = 1
  call run_live_lib#SwitchToWindow(a:window_number)
endfunction

"}}}

function! run_live_lib#SwitchToWindow(window_number)
  execute a:window_number . 'wincmd w'
endfunction

function! run_live_lib#FindOrCreateWindowByName(window_name)
  let l:window_number = bufwinnr(a:window_name)

  if l:window_number > 0
    call <SID>BypassThresholdCheckAndSwitchWindow(l:window_number)
  else
    call run_live_lib#CreateTemporaryWindow('rightbelow split', a:window_name)
  endif
endfunction

function! run_live_lib#Append(result)
  call append(0, split(a:result, '\v\n'))
  normal! gg
endfunction

function! run_live_lib#ClearScreen()
  normal! ggdG
endfunction

function! run_live_lib#GetContentList()
  return getline(1, '$')
endfunction

function! run_live_lib#WriteToFile(list)
  let s:temp_file = tempname()
  call writefile(a:list, s:temp_file)
  return s:temp_file
endfunction

function! run_live_lib#GetSelectedContentList()
  let user_yanked_content = @@

  silent execute "normal! `<v`>y"
  let selected_content = @@

  let @@ = user_yanked_content

  return split(selected_content, "\n")
endfunction

function! run_live_lib#CloseWindow(window_name)
  let l:window_number = bufwinnr(a:window_name)

  if window_number > 0
    call <SID>BypassThresholdCheckAndSwitchWindow(l:window_number)
    wincmd q
  endif
endfunction

function! run_live_lib#CreateTemporaryWindow(split_type, window_name)
  execute a:split_type . ' ' . a:window_name
  setlocal bufhidden=wipe buftype=nofile
endfunction

" When content is lesser than window height, reduce height to match content.
function! run_live_lib#AdjustWindowHeight()
  if <SID>IsHorizontalSplit()
    let l:half_vim_height = &lines/2
    let l:content_height = line('$')
    let l:adjusted_height = min([l:half_vim_height, l:content_height])
    execute 'resize ' . l:adjusted_height
  endif
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
