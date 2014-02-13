require 'support/spec_helper'

describe "run-mode" do
  before do
    vim.edit 'file.rb'
    vim.command("let b:run_live_command = 'ruby'")

    @content = <<-END
      def say
        puts 'Hello World'
      end

      say
    END
  end

  it "must print results taking optimal height" do
    ## Given
    vim.insert(@content)

    ## When
    vim.run_entire_file
    sleep 1
    vim.switch_to_results_window

    ## Then
    vim.number_of_lines.must_be :<=, 2
    vim.window_content.must_match 'Hello World'
  end

  it "must retain first line position in parent window" do
    ## Given
    vim.insert(@content)

    ## When
    vim.run_entire_file
    sleep 1

    ## Then
    vim.first_visible_line_number.must_equal 1
  end

  it "must retain original positioning of source content" do
    ## Given
    vim.insert(@content)
    vim.normal('<C-e>')
    sleep 1
    original_first_visible_line_number = vim.first_visible_line_number

    ## When
    vim.run_entire_file
    sleep 1

    ## Then
    vim.first_visible_line_number.must_equal original_first_visible_line_number
  end
end
