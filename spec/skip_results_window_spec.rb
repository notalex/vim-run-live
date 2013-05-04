require 'support/spec_helper'

describe "run-mode with results window skip" do
  before do
    vim.edit '_one_'
    vim.command("let b:run_live_command = 'ruby'")
  end

  it "wont land in results window when a threshold is set" do
    ## Given
    vim.command('let g:run_live_results_window_skip_threshold = 2')
    vim.command('botright vsplit _two_')
    vim.switch_to_window('_one_')
    vim.insert("p 'Hello World'")

    ## When
    vim.run_entire_file
    vim.normal('<C-w>w')

    ## Then
    vim.current_window_name.must_equal '_two_'

    ## When
    vim.normal('<C-w>w')

    ## Then
    vim.current_window_name.must_equal '_one_'
  end

  it "must not affect the dimensions of other horizontally split windows" do
    ## Given
    vim.command('let g:run_live_results_window_skip_threshold = 2')
    vim.command('botright vsplit _two_')
    other_window_height = vim.echo("winheight('.')")
    vim.switch_to_window('_one_')
    vim.insert("p 'Hello World'")

    ## When
    vim.run_entire_file
    vim.run_entire_file

    ## Then
    vim.switch_to_window('_two_')
    vim.echo("winheight('.')").must_equal other_window_height
  end
end
