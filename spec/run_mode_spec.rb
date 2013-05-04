require 'support/spec_helper'

describe "run-mode" do
  before do
    vim.edit 'file.rb'
    vim.command("let b:run_live_command = 'ruby'")
  end

  it "must print results taking optimal height" do
    ## Given
    vim.insert("p 'Hello World'")

    ## When
    vim.run_entire_file
    sleep 1
    vim.switch_to_results_window

    ## Then
    vim.number_of_lines.must_be :<=, 2
    vim.window_content.must_match 'Hello World'
  end
end
