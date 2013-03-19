# Vim Run Live

This plugin can...

* Run a specified shell command on an entire buffer.
* Run a specified shell command for a selection.
* Watch for changes in the buffer and run a shell command automatically.

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

Other than the 2 installation steps, this plugin requires no additional configuration to get started. In the above example when `<Leader>r` or `:WatchBuffer` is run, the plugin will ask for the shell command to associate with the current buffer

![](https://raw.github.com/notalex/vim-run-live/screenshots/screenshots/shell-command-prompt.png)
_Each buffer can have its own results window and its own separate shell command._

> For a more permanent usage, one may use the ftplugin folder or an autocommand.

### Ftplugin

Vim detects the file type and reads the appropriate file from the ftplugin directory. For example, to add a coffeescript mapping for _run_live_:

```vim
" ~/.vim/ftplugin/coffee.vim
let b:run_live_command = 'coffee -s'
```

### Autocommand

It simpler to just add an autocommand for the mapping.

```vim
" ~/.vimrc
autocmd! FileType coffee let b:run_live_command = 'coffee -s'
```

## The Awesome Parts

### Automatically saving autocommand

> This plugin also provides a way to automatically save user entered shell command for future use.

```vim
" ~/.vimrc
let g:run_live_remember_shell_command = 1
```

The next time, _run_live_ asks for a shell command for a coffeesript file, it will append the shell command to an appropriate ftplugin file.

```vim
" ~/.vim/ftplugin/coffee.vim
let b:run_live_command = 'coffee -s'
```

### Skipping results window

> This plugin includes a setting to control skipping results window during window navigation.

```vim
" ~/.vimrc
let g:run_live_results_window_skip_threshold = 2
```

When the number of windows in the current tab exceeds the threshold number, the results window will be skipped during window navigation.

### Running separate commands for run and live modes

> There are individual commands for run and live modes in addition to the common `b:run_live_command`. This can be helpful for languages like **coffeescript**.

```vim
" ~/.vimrc
let b:run_mode_command = 'coffee -s'
let b:live_mode_command = 'coffee -scb'
```

![](https://raw.github.com/notalex/vim-run-live/screenshots/screenshots/run-live-mode-commands.png)

## Help

```vim
:help run-live
```

## Additional Notes

> This plugin is sourced using Vim's autoload feature and hence it takes no toll on Vim's start up time(which is minimal anyways).

## Installation

> If you don't have a preferred installation method, I recommend using [Vundle][vundle_link]

With Vundle, you may simply add **Bundle 'notalex/vim-run-live'** to your *.vimrc* and run

    :BundleInstall

[vundle_link]: https://github.com/gmarik/vundle
