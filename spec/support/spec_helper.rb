require 'tmpdir'
require 'vimrunner'
require 'vimrunner/testing'
require 'minitest/autorun'
require 'support/vimrunner_core_extensions'
require 'support/vimrunner_custom_extensions'

include Vimrunner::Testing

def vim
  @vim ||= Vimrunner.start
end

class MiniTest::Spec
  before do
    vim.command("cd #{ tmp_dir_path }")
    plugin_path = File.expand_path('../../../', __FILE__)
    vim.add_plugin(plugin_path, 'plugin/run_live.vim')
  end

  after do
    remove_tmp_directory
    vim.kill
  end

  private

  def tmp_dir_path
    @tmp_dir_path ||= Dir.mktmpdir('vimrunner')
  end

  def remove_tmp_directory
    FileUtils.remove_entry(tmp_dir_path)
  end
end
