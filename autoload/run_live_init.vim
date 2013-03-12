" Should contain common initialization functions.

" Private functions{{{

  function! s:SaveAutocommand(command_name, command)
    let autocommand = 'autocmd! FileType ' . &filetype . ' let b:' . a:command_name . ' = ' . shellescape(a:command)
    execute autocommand
    call system("echo " . shellescape(autocommand) . " >> " . $MYVIMRC)
  endfunction

" }}}

function! run_live_init#CommandSetup(mode)
  let error_message = ''
  let input_message = 'Please enter a command to run for this buffer: '
  let command_name = a:mode . '_command'

  if !exists('b:{command_name}')
    if exists('b:run_live_command')
      let b:{command_name} = b:run_live_command
    else
      echohl WarningMsg
      let user_input = input(input_message)
      echohl None

      if strlen(user_input)
        let b:{command_name} = user_input

        if g:run_live_remember_entered_command
          call s:SaveAutocommand(command_name, user_input)
        endif
      else
        let error_message = 'Please define b:run_live_command. See :help run_live for more details.'
      endif
    endif
  endif

  return error_message
endfunction
