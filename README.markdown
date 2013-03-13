# Vim Run Live

This plugin can...

* Run an entire buffer
* Run a specific selection
* Watch for changes and run buffer

One needs to specify the shell command needed to run the buffer. The plugin will prompt for a shell command when its missing and can also save the shell command for future use. 

There are primarily two modes. Run and Live.

## Run Mode

The default run mode mapping is `<Leader>r` (`<Leader>` is backslash by default.)

![](https://raw.github.com/notalex/vim-run-live/screenshots/screenshots/after-run-mode.png)

_The results window height adjusts according to its content._
![](https://raw.github.com/notalex/vim-run-live/screenshots/screenshots/after-run-selection.png)

## Live Mode

Live mode runs a specified shell command for the contents of the current buffer when certain events are triggered. The default events are leaving Insert mode and writing the current buffer.

Live mode is triggered by the plugin command `:WatchBuffer`

![](https://raw.github.com/notalex/vim-run-live/screenshots/screenshots/after-live-mode.png)

## Configuration

> Other than the 2 installation steps, this plugin requires no additional configuration to get started. In the above example when `<Leader>r` or `:WatchBuffer` is run, the plugin will ask for the shell command to associate with the current buffer

![](https://raw.github.com/notalex/vim-run-live/screenshots/screenshots/shell-command-prompt.png)
_Each buffer can have its own results window and its own separate shell command._

> For a more permanent usage, one can use the ftplugin folder or an autocommand.

### ftplugin

Vim detects the file type and reads the appropriate file from the ftplugin directory. For example, to add a coffeescript mapping for run_live:

```vim
" ~/.vim/ftplugin/coffee.vim
let b:run_live_command = 'coffee'
```

### One may also simply add a autocmd for the mapping.

```vim
  autocmd! FileType coffee let b:run_live_command = 'coffee'
```

> This plugin also provides a way to save user entered shell command for future use. 

```vim
  let g:run_live_remember_entered_command = 1
```

## Additional Notes

> This plugin is sourced using Vim's autoload feature and hence it takes no toll on Vim's start up time(which is minimal anyways).

## Installation

> If you don't have a preferred installation method, I recommend using [Vundle][vundle_link]

With Vundle, you may simply add **Bundle 'notalex/vim-run-live'** to your *.vimrc* and run

    :BundleInstall

[vundle_link]:(https://github.com/gmarik/vundle)
