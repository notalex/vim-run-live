require 'support/spec_helper'

describe "run-mode" do
  before do
    vim.edit 'file.rb'
    vim.normal(":let b:run_live_command = 'ruby'<cr>")
  end

  it "should echo hello world" do
    input = normalize_string_indent(<<-END)
      p 'Hello World'
    END

    vim.insert(input)
    vim.normal(':call runner#InitializeAndRun(0)<cr>')
    vim.command("echo bufwinnr('Run_Results')").to_i.must_be :>, 0
  end
end
