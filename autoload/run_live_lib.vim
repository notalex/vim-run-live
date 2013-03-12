" Should contain independent reusable functions.

function! run_live_lib#SwitchToWindow(window_number)
  execute a:window_number . 'wincmd w'
endfunction

function! run_live_lib#Append(result)
  call setline(1, split(a:result, '\v\n'))
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
