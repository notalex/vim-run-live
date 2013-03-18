" Should contain common initialization functions.

" Initialization {{{1

if exists('g:loaded_run_live_init')
  finish
else
  let g:loaded_run_live_init = 1
endif

let s:vim_path = $HOME . '/.vim'
let s:vim_plugin_path = s:vim_path . '/plugin'
" }}}

" Private functions{{{1
function! s:CreateVimPluginFolder()
  silent! call mkdir(s:vim_path)
  silent! call mkdir(s:vim_plugin_path)
endfunction

function! s:SaveAutocommand(command_name, command)
  let autocommand = 'autocmd! FileType ' . &filetype . ' let ' . a:command_name . ' = ' . shellescape(a:command)
  " Add autocommand to current vim's memory.
  execute autocommand
  " Detecting filetype executes the associated autocommand for current buffer.
  filetype detect

  call s:CreateVimPluginFolder()
  call system("echo " . shellescape(autocommand) . " >> " . s:vim_plugin_path . '/run_live_autocommands.vim')
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
          call s:SaveAutocommand('b:run_live_command', user_input)
        endif
      else
        let error_message = 'Please define b:run_live_command. See :help run_live for more details.'
      endif
    endif
  endif

  return error_message
endfunction
